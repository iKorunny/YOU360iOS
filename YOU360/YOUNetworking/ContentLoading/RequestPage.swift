//
//  RequestPage.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 4/14/24.
//

import Foundation

public struct RequestPage {
    public let offset: Int
    public let size: Int
    
    public var jSON: [String: Int] {
        return [
            "offset": offset,
            "size": size
        ]
    }
    
    public init(offset: Int, size: Int) {
        self.offset = offset
        self.size = size
    }
}
