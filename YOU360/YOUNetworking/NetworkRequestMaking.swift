//
//  NetworkRequestMaking.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation

public protocol NetworkRequestMaking {
    func makeRequest(with url: URL,
                     headerAcceptValue: String,
                     headerContentTypeValue: String,
                     method: RequestMethod,
                     json: [String: Any]?) -> URLRequest
    func makeAuthorizedRequest(with url: URL,
                               headerAcceptValue: String,
                               headerContentTypeValue: String,
                               token: String,
                               method: RequestMethod,
                               json: [String: Any]?) -> URLRequest
    func makeRefreshRequest(with url: URL,
                            headerAcceptValue: String,
                            headerContentTypeValue: String,
                            refreshToken: String,
                            method: RequestMethod) -> URLRequest
}

public enum RequestMethod: String {
    case post = "POST"
    case get = "GET"
}

public final class NetworkRequestMaker: NetworkRequestMaking {
    
    static var shared = {
       return NetworkRequestMaker()
    }()
    
    public func makeRequest(with url: URL,
                            headerAcceptValue: String,
                            headerContentTypeValue: String,
                            method: RequestMethod,
                            json: [String: Any]?) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.addValue(headerAcceptValue, forHTTPHeaderField: "Accept")
        request.addValue(headerContentTypeValue, forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = method.rawValue
        
        request.addValue(Locale.current.identifier, forHTTPHeaderField: "Accept-Language")
        
        if let json = json {
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])
        }
        
        return request
    }
    
    public func makeAuthorizedRequest(with url: URL, 
                                      headerAcceptValue: String,
                                      headerContentTypeValue: String,
                                      token: String,
                                      method: RequestMethod,
                                      json: [String : Any]?) -> URLRequest {
        var request = makeRequest(with: url, 
                                  headerAcceptValue: headerAcceptValue, 
                                  headerContentTypeValue: headerContentTypeValue, 
                                  method: method,
                                  json: json)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    public func makeRefreshRequest(with url: URL, 
                                   headerAcceptValue: String,
                                   headerContentTypeValue: String,
                                   refreshToken: String,
                                   method: RequestMethod) -> URLRequest {
        let request = makeRequest(with: url,
                                  headerAcceptValue: headerAcceptValue,
                                  headerContentTypeValue: headerContentTypeValue,
                                  method: method,
                                  json: [
                                    "refreshToken" : refreshToken
                                  ])
        
        return request
    }
}
