//
//  ProfileContent.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 4/14/24.
//

import Foundation

final class ProfileContent: Codable {
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case contentUrl = "contentUrl"
        case previewUrl = "previewUrl"
        case contentTypeFull = "contentTypeFull"
        case contentTypeCompressed = "contentTypeCompressed"
        case fullName = "fullName"
        case compressedName = "compressedName"
    }
    
    var id: String
    var contentUrl: String
    var previewUrl: String
    var contentTypeFull: String
    var contentTypeCompressed: String
    var fullName: String
    var compressedName: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(contentUrl, forKey: .contentUrl)
        try container.encode(previewUrl, forKey: .previewUrl)
        try container.encode(contentTypeFull, forKey: .contentTypeFull)
        try container.encode(contentTypeCompressed, forKey: .contentTypeCompressed)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(compressedName, forKey: .compressedName)
    }
}

final class ProfileContentPage: Codable {
    private enum CodingKeys : String, CodingKey {
        case items = "items"
        case offset = "offset"
        case size = "size"
        case totalCount = "totalCount"
        case hasNextItem = "hasNextItem"
        case hasPreviousItem = "hasPreviousItem"
    }
    
    var items: [ProfileContent]
    var offset: Int
    var size: Int
    var totalCount: Int
    var hasNextItem: Bool
    var hasPreviousItem: Bool
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
        try container.encode(offset, forKey: .offset)
        try container.encode(size, forKey: .size)
        try container.encode(totalCount, forKey: .totalCount)
        try container.encode(hasNextItem, forKey: .hasNextItem)
        try container.encode(hasPreviousItem, forKey: .hasPreviousItem)
    }
}
