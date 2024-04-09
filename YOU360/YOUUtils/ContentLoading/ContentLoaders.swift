//
//  ContentLoaders.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/9/24.
//

import Foundation

public final class ContentLoaders {
    private static let accessQueue = ContentLoadersAccessQueue()
    
    public static let imageLoader = ImageLoader(accessQueue: accessQueue)
}

final class ContentLoadersAccessQueue {
    let queue = DispatchQueue(label: "ContentLoadersAccessQueue", qos: .utility)
}
