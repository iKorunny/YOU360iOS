//
//  PageResponse.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 6/10/24.
//

import Foundation

public final class PageResponse<T: Codable>: Codable {
    public var items: [T]
    public var offset: Int
    public var size: Int
    public var totalCount: Int
    public var hasNextItem: Bool
    public var hasPreviousItem: Bool
}
