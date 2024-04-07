//
//  Profile.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 3/1/24.
//

import Foundation
public enum ProfileVerification: Int, Decodable {
    case no
    case verified
}

public final class Profile: Codable {
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case email = "email"
        case userName = "userName"
        case name = "name"
        case surname = "surname"
        case aboutMe = "aboutMe"
        case dateOfBirth = "dateOfBirth"
        case city = "city"
//        case paymentMethod = "paymentMethod"
        case instagram = "instagram"
        case facebook = "facebook"
        case twitter = "twitter"
        case posts = "posts"
        case events = "events"
        case establishments = "establishments"
        case photoAvatarUrl = "photoAvatarUrl"
        case photoBackgroundUrl = "photoBackgroundUrl"
        case verification = "verification"
    }
    
    public var id: String
    public var email: String
    public var userName: String
    
    public var name: String?
    public var surname: String?
    public var aboutMe: String?
    public var dateOfBirth: String?
    public var city: String?
//    public var paymentMethod
    public var instagram: String?
    public var facebook: String?
    public var twitter: String?
    public var posts: Int
    public var events: Int
    public var establishments: Int
    public var photoAvatarUrl: String?
    public var photoBackgroundUrl: String?
    public var verification: ProfileVerification
    
    
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
//        try container.encode(paymentMethod, forKey: .paymentMethod)
        try container.encode(instagram, forKey: .instagram)
        try container.encode(facebook, forKey: .facebook)
        try container.encode(twitter, forKey: .twitter)
        try container.encode(posts, forKey: .posts)
        try container.encode(events, forKey: .events)
        try container.encode(establishments, forKey: .establishments)
        try container.encode(photoAvatarUrl, forKey: .photoAvatarUrl)
        try container.encode(photoBackgroundUrl, forKey: .photoBackgroundUrl)
        try container.encode(verification.rawValue, forKey: .verification)
    }
    
    public init() {
        id = ""
        email = ""
        userName = ""
        posts = 0
        events = 0
        establishments = 0
        verification = .no
    }
}
