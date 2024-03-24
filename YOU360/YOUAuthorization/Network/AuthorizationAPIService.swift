//
//  AuthorizationAPIService.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/26/24.
//

import Foundation
import YOUNetworking
import YOUProfileInterfaces

final class AuthorizationAPIError {
    let stringRepresentation: String
    
    init(stringRepresentation: String) {
        self.stringRepresentation = stringRepresentation
    }
}

final class AuthorizationAPIService {
    static var shared = AuthorizationAPIService()
    
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
    
    func requestLogin(email: String, password: String, completion: @escaping ((Bool, [AuthorizationAPIError], Profile?, String?) -> Void)) {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("User/Login")
        
        let request = requestMaker.makeDatataskRequest(with: url,
                                                       headerAcceptValue: "application/json",
                                                       headerContentTypeValue: "application/json",
                                                       method: .post,
                                                       json: [
                                                        "email" : email,
                                                        "password" : password
                                                       ])
        
        dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            var errors: [AuthorizationAPIError] = []
            if let error = error {
                errors.append(AuthorizationAPIError(stringRepresentation: error.localizedDescription))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, errors, nil, nil)
                }
                return
            }
            
            var profile: Profile?
            let success = httpResponse.statusCode == 200
            if success {
                guard let data = data else { return }
                profile = try? JSONDecoder().decode(Profile.self, from: data)
            }
            else {
                guard let data = data,
                let errorsJSON = try? JSONSerialization.jsonObject(with: data) as? [String:[String]],
                let errorsString = errorsJSON["errors"] else { return }
                
                errorsString.forEach({ errors.append(AuthorizationAPIError(stringRepresentation: $0)) })
            }
            
            DispatchQueue.main.async {
                completion(errors.isEmpty && success, errors, profile, httpResponse.value(forHTTPHeaderField: "X-Token"))
            }
        })
        
        dataTask?.resume()
    }
    
    func requestRegister(email: String, password: String, completion: @escaping ((Bool, [AuthorizationAPIError], Profile?, String?) -> Void)) {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("User/Register")
        
        let request = requestMaker.makeDatataskRequest(with: url,
                                                       headerAcceptValue: "application/json",
                                                       headerContentTypeValue: "application/json",
                                                       method: .post,
                                                       json: [
                                                        "email" : email,
                                                        "password" : password
                                                       ])
        
        dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            var errors: [AuthorizationAPIError] = []
            if let error = error {
                errors.append(AuthorizationAPIError(stringRepresentation: error.localizedDescription))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, errors, nil, nil)
                }
                return
            }
            
            var profile: Profile?
            let success = httpResponse.statusCode == 200
            if success {
                guard let data = data else { return }
                profile = try? JSONDecoder().decode(Profile.self, from: data)
            }
            else {
                guard let data = data,
                let errorsJSON = try? JSONSerialization.jsonObject(with: data) as? [String:[String]],
                let errorsString = errorsJSON["errors"] else { return }
                
                errorsString.forEach({ errors.append(AuthorizationAPIError(stringRepresentation: $0)) })
            }
            
            DispatchQueue.main.async {
                completion(errors.isEmpty && success, errors, profile, httpResponse.value(forHTTPHeaderField: "X-Token"))
            }
        })
        
        dataTask?.resume()
    }
}
