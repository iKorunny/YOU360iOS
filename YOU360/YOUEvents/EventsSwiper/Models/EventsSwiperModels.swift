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

final class EventsPrice {
    let amount: CGFloat
    let currencySymbol: String
    
    init(amount: CGFloat, currencySymbol: String) {
        self.amount = amount
        self.currencySymbol = currencySymbol
    }
}

final class EventsSwiperEvent {
    let type: EventsSwiperEventType
    let urlString: String
    let price: EventsPrice
    let date: Date
    
    init(type: EventsSwiperEventType, 
         urlString: String,
         price: EventsPrice,
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
