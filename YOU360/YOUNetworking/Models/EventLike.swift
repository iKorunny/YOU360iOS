//
//  EventLike.swift
//  YOUNetworking
//
//  Created by Andrei Tamila on 5/5/24.
//

import Foundation

public class EventLike: Decodable {
    
    let userId: String
    let eventId: String
    
    enum CodingKeys: CodingKey {
        case userId
        case eventId
    }
    
    required public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<EventLike.CodingKeys> = try decoder.container(keyedBy: EventLike.CodingKeys.self)
        
        self.userId = try container.decode(String.self, forKey: EventLike.CodingKeys.userId)
        self.eventId = try container.decode(String.self, forKey: EventLike.CodingKeys.eventId)
    }
}
