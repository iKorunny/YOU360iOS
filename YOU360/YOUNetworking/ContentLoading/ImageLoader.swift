//
//  ImageLoader.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/9/24.
//

import Foundation
import UIKit

public final class ImageLoader {
    private lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfig.urlCache = DownloadCaches.getContentCache()
        return URLSession(configuration: sessionConfig)
    }()
    
    private lazy var requester: NetworkRequestPerformer = {
       return NetworkRequestPerformer(session: session)
    }()
    
    /**
     GET
    */
    public func dataTaskToLoadImage(with url: URL?, completion: @escaping ((UIImage?) -> Void)) -> URLSessionDataTask? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        request.httpMethod = "GET"
        
        let task: URLSessionDataTask? = requester.performDataTask(from: request) { data, response, error, performerError in
            var image: UIImage?
            
            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            guard let data = data,
                  error == nil,
                  performerError == nil,
                  response?.isSuccess == true else {
                return
            }
            
            image = UIImage(data: data)
        }
        
        
        task?.resume()
        return task
    }
}
