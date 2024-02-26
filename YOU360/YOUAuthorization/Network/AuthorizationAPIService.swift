//
//  AuthorizationAPIService.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/26/24.
//

import Foundation
import YOUNetworking

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
    
    func requestLogin(email: String, password: String, completion: @escaping ((Bool, AuthorizationAPIError?, Data?, String?) -> Void)) {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("User/Login")
        
        let request = requestMaker.makeDatataskRequest(with: url,
                                                       headerAcceptValue: "application/json",
                                                       headerContentTypeValue: "application/json",
                                                       method: .post,
                                                       json: [
                                                        "userName" : email,
                                                        "password" : password
                                                       ])
        
        dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            var parsedError: AuthorizationAPIError?
            if let error = error {
                parsedError = AuthorizationAPIError(stringRepresentation: error.localizedDescription)
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, parsedError, nil, nil)
                return
            }
            
            // String.init(data: data!, encoding: .utf8) // now token received as body.
            
            completion(error == nil && httpResponse.statusCode == 200, parsedError, data, httpResponse.value(forHTTPHeaderField: "X-Token"))
        })
        
        dataTask?.resume()
    }
}
