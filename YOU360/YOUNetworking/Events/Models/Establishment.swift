//
//  Establishment.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 6/10/24.
//

import Foundation

public final class EstablishmentSubscription: Codable {
    public var id: String
    public var startDate: String?
    public var endDate: String?
    public var establishmentId: String?
}

public final class EstablishmentAddress: Codable {
    public var id: String
    public var latitude: Double
    public var longitude: Double
    public var country: String?
    public var region: String?
    public var city: String?
    public var street: String?
    public var zipCode: String?
    public var houseNumber: String?
}

public final class EstablishmentWorkingDay: Codable {
    public var id: String
    public var dayOfWeek: Int
    public var openingTime: String?
    public var closingTime: String?
    public var establishmentId: String?
}

public final class Establishment: Codable {
    public var id: String
    public var websiteUrl: String?
    public var instagram: String?
    public var facebook: String?
    public var twitter: String?
    public var name: String?
    public var description: String?
    public var category: Int //TODO: change to enum later
    public var phoneNumber: String?
    public var placeAddress: String?
    public var background: ContentResponse?
    public var backgroundId: String?
    public var avatar: ContentResponse?
    public var avatarId: String?
    public var userId: String?
    public var subscription: EstablishmentSubscription?
    public var address: EstablishmentAddress?
    public var workingDays: [EstablishmentWorkingDay]
    public var eventsCount: Int
    public var subscribersCount: Int
    public var postsCount: Int
    public var tablesCount: Int
    public var menusCount: Int
    public var certificatesCount: Int
    public var roomsCount: Int
}
