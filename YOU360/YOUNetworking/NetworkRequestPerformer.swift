//
//  NetworkRequestPerformer.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 4/18/24.
//

import Foundation
import YOUUtils

public enum YOUNetworkRequestError {
    case noInternet
}

public final class NetworkRequestPerformer {
    private let session: URLSession
    public init(session: URLSession) {
        self.session = session
    }
    
    public func performDataTask(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?, YOUNetworkRequestError?) -> Void) -> URLSessionDataTask? {
        guard InternetConnectionManager.shared.isInternetAvailable() else {
            completion(nil, nil, nil, .noInternet)
            return nil
        }
        return session.dataTask(with: request) {
            completion($0, $1, $2, nil)
        }
    }
}
