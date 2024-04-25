//
//  EventsSwiperContentVCDataSource.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/25/24.
//

import Foundation

protocol EventsSwiperContentVCDataSource {
    var models: [EventsSwiperBussiness] { get }
    var isFirstBussiness: Bool { get }
    var isLastBussiness: Bool { get }
    var isLastEvent: Bool { get }
    var isFirstEvent: Bool { get }
    
    var nextBussiness: EventsSwiperBussiness? { get }
    var previousBussiness: EventsSwiperBussiness? { get }
    var nextEvent: EventsSwiperEvent? { get }
    var previousEvent: EventsSwiperEvent? { get }
    
    var bussiness: EventsSwiperBussiness? { get }
    var event: EventsSwiperEvent? { get }
}

final class EventsSwiperContentVCDataSourceImpl {
    let models: [EventsSwiperBussiness]
    private var bussinessIndex: Int = 0
    private var eventIndex: Int = 0
    
    private var events: [EventsSwiperEvent] {
        guard bussinessIndex < models.count, bussinessIndex >= 0 else { return [] }
        return models[bussinessIndex].events
    }
    
    init(with models: [EventsSwiperBussiness]) {
        self.models = models
    }
}

extension EventsSwiperContentVCDataSourceImpl: EventsSwiperContentVCDataSource {
    var bussiness: EventsSwiperBussiness? {
        guard bussinessIndex >= 0, bussinessIndex < models.count else { return nil }
        return models[bussinessIndex]
    }
    
    var event: EventsSwiperEvent? {
        guard eventIndex >= 0, eventIndex < events.count else { return nil }
        return events[eventIndex]
    }
    
    var isFirstBussiness: Bool {
        bussinessIndex == 0
    }
    
    var isLastBussiness: Bool {
        bussinessIndex >= (models.count - 1)
    }
    
    var isLastEvent: Bool {
        eventIndex >= (events.count - 1)
    }
    
    var isFirstEvent: Bool {
        eventIndex == 0
    }
    
    var nextBussiness: EventsSwiperBussiness? {
        let newIndex = bussinessIndex + 1
        guard newIndex < models.count else { return nil }
        bussinessIndex = newIndex
        eventIndex = 0
        return models[bussinessIndex]
    }
    
    var previousBussiness: EventsSwiperBussiness? {
        let newIndex = bussinessIndex - 1
        guard newIndex >= 0 else { return nil }
        bussinessIndex = newIndex
        eventIndex = 0
        return models[bussinessIndex]
    }
    
    var nextEvent: EventsSwiperEvent? {
        let newIndex = eventIndex + 1
        guard newIndex < events.count else { return nil }
        eventIndex = newIndex
        return events[eventIndex]
    }
    
    var previousEvent: EventsSwiperEvent? {
        let newIndex = eventIndex - 1
        guard newIndex >= 0 else { return nil }
        eventIndex = newIndex
        return events[eventIndex]
    }
    
    
}
