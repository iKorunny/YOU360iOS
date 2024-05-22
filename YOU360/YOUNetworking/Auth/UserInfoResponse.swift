//
//  UserInfoResponse.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 3/1/24.
//

import Foundation

public enum ProfileVerification: Int, Codable {
    case no
    case verified
}

public final class UserInfoResponse: Codable {
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case email = "email"
        case userName = "userName"
        case name = "name"
        case surname = "surname"
        case aboutMe = "aboutMe"
        case dateOfBirth = "dateOfBirth"
        case city = "city"
        case paymentMethod = "paymentMethod"
        case instagram = "instagram"
        case facebook = "facebook"
        case twitter = "twitter"
        case postsCount = "postsCount"
        case likedEventsCount = "likedEventsCount"
        case ticketsCount = "ticketsCount"
        case establishmentsSubscriptionsCount = "establishmentsSubscriptionsCount"
        case reservationsCount = "reservationsCount"
        case verification = "verification"
        case background = "background"
        case backgroundId = "backgroundId"
        case avatar = "avatar"
        case avatarId = "avatarId"
        case establishmentId = "establishmentId"
    }
    
    public var id: String
    public var email: String
    public var userName: String
    
    public var name: String?
    public var surname: String?
    public var aboutMe: String?
    public var dateOfBirth: String?
    public var city: String?
    public var paymentMethod: String?
    public var instagram: String?
    public var facebook: String?
    public var twitter: String?
    public var postsCount: Int
    public var ticketsCount: Int
    public var likedEventsCount: Int
    public var establishmentsSubscriptionsCount: Int
    public var reservationsCount: Int
    public var avatar: ContentResponse?
    public var avatarId: String?
    public var background: ContentResponse?
    public var backgroundId: String?
    public var verification: ProfileVerification
    public var establishmentId: String?
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(userName, forKey: .userName)
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(aboutMe, forKey: .aboutMe)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(city, forKey: .city)
        try container.encode(paymentMethod, forKey: .paymentMethod)
        try container.encode(instagram, forKey: .instagram)
        try container.encode(facebook, forKey: .facebook)
        try container.encode(twitter, forKey: .twitter)
        try container.encode(postsCount, forKey: .postsCount)
        try container.encode(likedEventsCount, forKey: .likedEventsCount)
        try container.encode(establishmentsSubscriptionsCount, forKey: .establishmentsSubscriptionsCount)
        try container.encode(avatarId, forKey: .avatarId)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(background, forKey: .background)
        try container.encode(backgroundId, forKey: .backgroundId)
        try container.encode(verification.rawValue, forKey: .verification)
    }
    
    public init() {
        id = ""
        email = ""
        userName = ""
        postsCount = 0
        likedEventsCount = 0
        establishmentsSubscriptionsCount = 0
        reservationsCount = 0
        ticketsCount = 0
        verification = .no
    }
}
