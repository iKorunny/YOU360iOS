//
//  Content.swift
//  YOUNetworking
//
//  Created by Andrei Tamila on 5/5/24.
//

import Foundation

public class ContentResponse: Codable {

    public let id: String
    public let contentTypeFull: String
    public let contentTypeCompressed: String
    public let previewType: String
    public let contentUrl: String
    public let previewUrl: String
    public let contentName: String
    public let previewName: String
    
    enum CodingKeys: CodingKey {
        case id
        case contentTypeFull
        case contentTypeCompressed
        case previewType
        case contentUrl
        case previewUrl
        case contentName
        case previewName
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.contentTypeFull = try container.decode(String.self, forKey: .contentTypeFull)
        self.contentTypeCompressed = try container.decode(String.self, forKey: .contentTypeCompressed)
        self.previewType = try container.decode(String.self, forKey: .previewType)
        self.contentUrl = try container.decode(String.self, forKey: .contentUrl)
        self.previewUrl = try container.decode(String.self, forKey: .previewUrl)
        self.contentName = try container.decode(String.self, forKey: .contentName)
        self.previewName = try container.decode(String.self, forKey: .previewName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<ContentResponse.CodingKeys> = encoder.container(keyedBy: ContentResponse.CodingKeys.self)
        try container.encode(self.id, forKey: ContentResponse.CodingKeys.id)
        try container.encode(self.contentTypeFull, forKey: ContentResponse.CodingKeys.contentTypeFull)
        try container.encode(self.contentTypeCompressed, forKey: ContentResponse.CodingKeys.contentTypeCompressed)
        try container.encode(self.previewType, forKey: ContentResponse.CodingKeys.previewType)
        try container.encode(self.contentUrl, forKey: ContentResponse.CodingKeys.contentUrl)
        try container.encode(self.previewUrl, forKey: ContentResponse.CodingKeys.previewUrl)
        try container.encode(self.contentName, forKey: ContentResponse.CodingKeys.contentName)
        try container.encode(self.previewName, forKey: ContentResponse.CodingKeys.previewName)
    }
}
