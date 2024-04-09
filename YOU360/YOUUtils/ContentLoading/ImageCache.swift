//
//  ImageCache.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/9/24.
//

import Foundation

public final class ImageCache {
    private let writeQueue: ContentLoadersAccessQueue
    
    init(writeQueue: ContentLoadersAccessQueue) {
        self.writeQueue = writeQueue
    }
    
}
