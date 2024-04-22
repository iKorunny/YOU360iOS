//
//  AuthorizationAPIService.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/26/24.
//

import Foundation
import YOUNetworking
import YOUProfileInterfaces

final public class AuthorizationAPIError {
    private enum Constants {
        static let noInternetKey = "AuthorizationAPIErrorNoInternet"
        static let unknown = "AuthorizationAPIErrorUnknown"
    }
    
    public var isNoInternet: Bool {
        stringRepresentation == Constants.noInternetKey
    }
    
    let stringRepresentation: String
    
    init(stringRepresentation: String) {
        self.stringRepresentation = stringRepresentation
    }
    
    static func createNoInternet() -> AuthorizationAPIError {
        return AuthorizationAPIError(stringRepresentation: Constants.noInternetKey)
    }
    
    static func createUnknown() -> AuthorizationAPIError {
        return AuthorizationAPIError(stringRepresentation: Constants.unknown)
    }
    
    static func map(performerError: YOUNetworkRequestError) -> AuthorizationAPIError {
        switch performerError {
        case .noInternet:
            return createNoInternet()
        }
    }
    
    static func map(secretPartError: SecretPartNetworkLocalError) -> AuthorizationAPIError {
        switch secretPartError {
        case .noInternet:
            return createNoInternet()
        case .general:
            return createUnknown()
        }
    }
}

final public class AuthorizationAPIService {
    static public var shared = AuthorizationAPIService()
    
    private var requestMaker: NetworkRequestMaker {
        YOUNetworkingServices.requestMaker
    }
    private lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil
        return URLSession(configuration: sessionConfig)
    }()
    private lazy var requester: NetworkRequestPerformer = {
       return NetworkRequestPerformer(session: session)
    }()
    private var dataTask: URLSessionDataTask?
    
    func requestLogin(email: String, password: String, completion: @escaping ((Bool, [AuthorizationAPIError], Profile?, String?, String?) -> Void)) {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Auth/SignIn")
        
        let request = requestMaker.makeRequest(with: url,
                                               headerAcceptValue: "application/json",
                                               headerContentTypeValue: "application/json",
                                               method: .post,
                                               json: [
                                                "email" : email,
                                                "password" : password
                                               ])
        
        dataTask = requester.performDataTask(from: request) { data, response, error, performerError in
            var errors: [AuthorizationAPIError] = []
            
            if let performerError = performerError {
                errors.append(.map(performerError: performerError))
                DispatchQueue.main.async {
                    completion(false, errors, nil, nil, nil)
                }
                return
            }
            
            if let error = error {
                errors.append(AuthorizationAPIError(stringRepresentation: error.localizedDescription))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, errors, nil, nil, nil)
                }
                return
            }
            
            var profile: Profile?
            let success = httpResponse.isSuccess
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
                completion(errors.isEmpty && success,
                           errors,
                           profile,
                           httpResponse.value(forHTTPHeaderField: "x-token"),
                           httpResponse.value(forHTTPHeaderField: "r-token"))
            }
        }
        
        dataTask?.resume()
    }
    
    func requestRegister(email: String, password: String, completion: @escaping ((Bool, [AuthorizationAPIError], Profile?, String?, String?) -> Void)) {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Auth/SignUp")
        
        let request = requestMaker.makeRequest(with: url,
                                               headerAcceptValue: "application/json",
                                               headerContentTypeValue: "application/json",
                                               method: .post,
                                               json: [
                                                "email" : email,
                                                "password" : password
                                               ])
        
        dataTask = requester.performDataTask(from: request) { data, response, error, performerError in
            var errors: [AuthorizationAPIError] = []
            
            if let performerError = performerError {
                errors.append(.map(performerError: performerError))
                DispatchQueue.main.async {
                    completion(false, errors, nil, nil, nil)
                }
                return
            }
            if let error = error {
                errors.append(AuthorizationAPIError(stringRepresentation: error.localizedDescription))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, errors, nil, nil, nil)
                }
                return
            }
            
            var profile: Profile?
            let success = httpResponse.isSuccess
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
                completion(errors.isEmpty && success, 
                           errors, profile,
                           httpResponse.value(forHTTPHeaderField: "x-token"),
                           httpResponse.value(forHTTPHeaderField: "r-token"))
            }
        }
        
        dataTask?.resume()
    }
    
    public func requestLogout(completion: @escaping ((Bool, [AuthorizationAPIError]) -> Void)) {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Auth/Logout")
        
        let request = requestMaker.makeRequest(with: url,
                                                       headerAcceptValue: "application/json",
                                                       headerContentTypeValue: "application/json",
                                                       authToken: AuthorizationService.shared.token,
                                                       method: .post,
                                                       json: ["refreshToken": AuthorizationService.shared.refreshToken ?? ""])
        
        SecretPartNetworkService.shared.performDataTask(request: request) { data, response, error, secretPartError in
            var errors: [AuthorizationAPIError] = []
            if let secretPartError = secretPartError {
                errors.append(.map(secretPartError: secretPartError))
                DispatchQueue.main.async {
                    completion(false, errors)
                }
                return
            }
            if let error = error {
                errors.append(AuthorizationAPIError(stringRepresentation: error.localizedDescription))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, errors)
                }
                return
            }
            
            let success = httpResponse.isSuccess
            if success {
                guard let data = data else { return }
                print(data)
            }
            else {
                guard let data = data,
                let errorsJSON = try? JSONSerialization.jsonObject(with: data) as? [String:[String]],
                let errorsString = errorsJSON["errors"] else { return }
                
                errorsString.forEach({ errors.append(AuthorizationAPIError(stringRepresentation: $0)) })
            }
            
            DispatchQueue.main.async {
                completion(errors.isEmpty && success, errors)
            }
        }
    }
}
