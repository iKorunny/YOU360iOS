//
//  EventsSwiperModels.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/25/24.
//

import Foundation

enum EventsSwiperEventType {
    case unknown
    case image
    case video
    
    static func convert(string: String) -> EventsSwiperEventType {
        switch string {
        case "video":
            return .video
        case "image":
            return .image
        default:
            return .unknown
        }
    }
}

final class EventsSwiperEvent {
    let type: EventsSwiperEventType
    let urlString: String
    let price: String
    let date: Date
    
    init(type: EventsSwiperEventType, 
         urlString: String,
         price: String,
         date: Date) {
        self.type = type
        self.urlString = urlString
        self.price = price
        self.date = date
    }
}

final class EventsSwiperBussiness {
    let id: String
    let events: [EventsSwiperEvent]
    let likes: Int
    let name: String
    let address: String?
    let category: String?
    
    init(id: String,
         events: [EventsSwiperEvent],
         likes: Int,
         name: String,
         address: String?,
         category: String?) {
        self.id = id
        self.events = events
        self.likes = likes
        self.name = name
        self.address = address
        self.category = category
    }
}

extension EventsSwiperEvent {
    var url: URL? {
        URL(string: urlString)
    }
}
