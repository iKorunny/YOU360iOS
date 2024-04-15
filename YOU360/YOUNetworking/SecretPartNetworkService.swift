//
//  SecretPartNetworkService.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 4/5/24.
//

import Foundation
import YOUUtils

public enum SecretPartNetworkLocalError {
    case general
}

public final class SecretPartNetworkService {
    
    static public let shared = SecretPartNetworkService()
    
    public var authToken: String = ""
    public var refreshToken: String = ""
    
    private var requestMaker: NetworkRequestMaker {
        YOUNetworkingServices.requestMaker
    }
    private lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil
        return URLSession(configuration: sessionConfig)
    }()
    private var dataTask: URLSessionDataTask?
    
    private var refreshRequest: URLRequest {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Auth/RegenerateToken")
        
        return requestMaker.makeRefreshRequest(with: url,
                                               headerAcceptValue: "application/json",
                                               headerContentTypeValue: "application/json",
                                               refreshToken: refreshToken,
                                               method: .post)
    }
    
    init() {
        authToken = SafeStorage.getAuthToken() ?? ""
        refreshToken = SafeStorage.getRefreshToken() ?? ""
    }
    
    public func performDataTask(request: URLRequest, 
                                completion: @escaping ((Data?, URLResponse?, Error?, SecretPartNetworkLocalError?) -> Void)) {
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 401 else {
                completion(data, response, error, nil)
                return
            }
            
            let refreshDataTask = self.session.dataTask(with: self.refreshRequest) { [weak self] data, response, error in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let data = data,
                      let tokens = try? JSONDecoder().decode([String: String].self, from: data) else {
                    if httpResponse.statusCode == 400 || httpResponse.statusCode == 401 {
                        NotificationCenter.default.post(name: .onLogout, object: nil)
                    }
                    completion(data, response, error, .general)
                    return
                }
                
                var requestToRepeat = request
                if let refreshToken = tokens["refreshToken"] {
                    self?.refreshToken = refreshToken
                    SafeStorage.saveRefreshToken(refreshToken)
                }
                if let authToken = tokens["token"] {
                    self?.authToken = authToken
                    SafeStorage.saveAuthToken(authToken)
                    requestToRepeat.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                }
                
                self?.dataTask = self?.session.dataTask(with: requestToRepeat) { data, response, error in
                    completion(data, response, error, nil)
                }
                self?.dataTask?.resume()
            }
            refreshDataTask.resume()
        }
        dataTask?.resume()
    }
}
