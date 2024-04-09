//
//  ImageLoader.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/9/24.
//

import Foundation

public final class ImageLoader {
    private let accessQueue: ContentLoadersAccessQueue
    private let imageCache: ImageCache
    
    init(accessQueue: ContentLoadersAccessQueue) {
        self.accessQueue = accessQueue
        self.imageCache = ImageCache(writeQueue: accessQueue)
    }
    
    public func dataTaskToLoadImage(with url: URL?) -> URLSessionDataTask? {
        guard let url = url else { return nil }
        
        var task: URLSessionDataTask?
        
        return task
    }
}
