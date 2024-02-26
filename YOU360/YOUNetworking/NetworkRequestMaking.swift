//
//  NetworkRequestMaking.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation

public protocol NetworkRequestMaking {
    func makeDatataskRequest(with url: URL,
                             headerAcceptValue: String,
                             headerContentTypeValue: String,
                             method: RequestMethod,
                             json: [String: Any]?) -> URLRequest
}

public enum RequestMethod: String {
    case post = "POST"
}

public final class NetworkRequestMaker: NetworkRequestMaking {
    
    static var shared = {
       return NetworkRequestMaker()
    }()
    
    public func makeDatataskRequest(with url: URL, 
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
}
