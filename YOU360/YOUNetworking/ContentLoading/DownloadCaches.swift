//
//  DownloadCaches.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 4/22/24.
//

import Foundation

public final class DownloadCaches {
    private static var contentCache: URLCache?
    public static func getContentCache() -> URLCache {
        if let cache = contentCache {
            return cache
        }
        
        let cache = URLCache(memoryCapacity: 50000000, diskCapacity: 500000000)
        contentCache = cache
        return cache
    }
}
