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
        sessionConfig.urlCache = URLCache.shared
        sessionConfig.urlCache?.diskCapacity = 300000000 // 300 mb
        sessionConfig.urlCache?.memoryCapacity = 30000000 // 30 mb
        return URLSession(configuration: sessionConfig)
    }()
    
    public func dataTaskToLoadImage(with url: URL?, completion: @escaping ((UIImage?) -> Void)) -> URLSessionDataTask? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task: URLSessionDataTask? = session.dataTask(with: request) { data, response, error in
            var image: UIImage?
            
            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            guard let data = data,
                  error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return
            }
            
            image = UIImage(data: data)
        }
        
        
        task?.resume()
        return task
    }
}
