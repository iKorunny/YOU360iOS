//
//  EventsSwiperModels.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/25/24.
//

import Foundation

enum EventsSwiperEventType {
    case image
    case video
}

final class EventsSwiperEvent {
    let type: EventsSwiperEventType
    let urlString: String
    
    init(type: EventsSwiperEventType, 
         urlString: String) {
        self.type = type
        self.urlString = urlString
    }
}

final class EventsSwiperBussiness {
    let id: String
    let events: [EventsSwiperEvent]
    
    init(id: String, 
         events: [EventsSwiperEvent]) {
        self.id = id
        self.events = events
    }
}

extension EventsSwiperEvent {
    var url: URL? {
        URL(string: urlString)
    }
}
