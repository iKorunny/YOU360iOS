//
//  SingleImageLoader.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 4/22/24.
//

import Foundation

public protocol SingleImageLoading {
    init(with url: URL)
    func load(completion: @escaping ((Data?) -> Void))
    func stopLoading()
    func invalidate()
}

public final class SingleImageLoader: SingleImageLoading {
    private let url: URL
    private var dataTask: URLSessionDataTask?
    
    private var valid = true
    
    private lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfig.urlCache = DownloadCaches.getContentCache()
        return URLSession(configuration: sessionConfig)
    }()
    
    private lazy var requester: NetworkRequestPerformer = {
       return NetworkRequestPerformer(session: session)
    }()
    
    public init(with url: URL) {
        self.url = url
    }
    
    public func load(completion: @escaping ((Data?) -> Void)) {
        valid = true
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.httpMethod = "GET"
        
        dataTask = requester.performDataTask(from: request) { [weak self] data, response, error, performerError in
            guard self?.valid == true else { return }
            guard response?.isSuccess == true,
                  error == nil,
                  performerError == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            completion(data)
        }
        
        
        dataTask?.resume()
    }
    
    public func invalidate() {
        valid = false
    }
    
    public func stopLoading() {
        dataTask?.cancel()
    }
}
