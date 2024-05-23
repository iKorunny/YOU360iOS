//
//  ProfileContent.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 4/14/24.
//

import Foundation

public enum VisibilityInt: Int {
    case subsscribersOnly
    case `public`
}

public enum Visibility: Codable {
    case `public`
    case subsscribersOnly
    
    enum CodingKeys: String, CodingKey {
        case `public` = "Public"
        case subscribersOnly = "SubscribersOnly"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        switch value {
        case CodingKeys.public.rawValue:
            self = .public
        case CodingKeys.subscribersOnly.rawValue:
            self = .subsscribersOnly
        default:
            throw DecodingError.valueNotFound(Visibility.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid value: \(value)"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self)
    }
}

/*
    public Guid Id { get; init; }
     public string Description { get; init; } = null!;
     public Visibility Visibility { get; init; }
     public DateTime PublicationDate { get; init; }

     public List<ContentResponse> Contents { get; init; } = new List<ContentResponse>();
     public int ContentsCount;
     public UserInfoResponse? UserAuthor { get; init; }
     public Guid? UserAuthorId { get; init; }
     public EstablishmentResponse? EstablishmentAuthor { get; init; }
     public Guid? EstablishmentAuthorId { get; init; }
     public int LikesCount { get; init; }
     public int CommentsCount { get; init; }
 
 
 "userAuthorId": "f72d4638-43ff-49f5-bae5-dd0d769398f1",
 "establishmentAuthor": null,
 "establishmentAuthorId": null,
 "likesCount": 0,
 "commentsCount": 0
 */

public final class ProfileContent: Codable {
    public var id: String
    public var description: String?
    public var visibility: VisibilityInt
    public var publicationDate: String
    public var userAuthorId: String
    
    public var contents: [ProfileContentItem]
    public var userAuthor: UserInfoResponse
    public var establishmentAuthorId: String?
    public var establishmentAuthor: EstablishmentResponse?
    public var likesCount: Int
    public var commentsCount: Int
    
    enum CodingKeys: CodingKey {
        case id
        case description
        case visibility
        case publicationDate
        case userAuthorId
        case contents
        case userAuthor
        case establishmentAuthorId
        case establishmentAuthor
        case likesCount
        case commentsCount
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(description, forKey: .description)
        try container.encode(visibility.rawValue, forKey: .visibility)
        try container.encode(publicationDate, forKey: .publicationDate)
        try container.encode(userAuthorId, forKey: .userAuthorId)
        
        try container.encode(contents, forKey: .contents)
        try container.encode(userAuthor, forKey: .userAuthor)
        try container.encode(establishmentAuthorId, forKey: .establishmentAuthorId)
        try container.encode(establishmentAuthor, forKey: .establishmentAuthor)
        try container.encode(likesCount, forKey: .likesCount)
        try container.encode(commentsCount, forKey: .commentsCount)
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<ProfileContent.CodingKeys> = try decoder.container(keyedBy: ProfileContent.CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: ProfileContent.CodingKeys.id)
        let visibilityValue = try container.decode(Int.self, forKey: ProfileContent.CodingKeys.visibility)
        self.visibility = VisibilityInt(rawValue: visibilityValue) ?? .public
        self.publicationDate = try container.decode(String.self, forKey: ProfileContent.CodingKeys.publicationDate)
        self.userAuthorId = try container.decode(String.self, forKey: ProfileContent.CodingKeys.userAuthorId)
        self.contents = try container.decode([ProfileContentItem].self, forKey: ProfileContent.CodingKeys.contents)
        self.userAuthor = try container.decode(UserInfoResponse.self, forKey: ProfileContent.CodingKeys.userAuthor)
        self.establishmentAuthorId = try container.decodeIfPresent(String.self, forKey: ProfileContent.CodingKeys.establishmentAuthorId)
        self.establishmentAuthor = try container.decodeIfPresent(EstablishmentResponse.self, forKey: ProfileContent.CodingKeys.establishmentAuthor)
        self.likesCount = try container.decode(Int.self, forKey: ProfileContent.CodingKeys.likesCount)
        self.commentsCount = try container.decode(Int.self, forKey: ProfileContent.CodingKeys.commentsCount)
    }
}


public final class ProfileContentItem: Codable {
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case contentUrl = "contentUrl"
        case previewUrl = "previewUrl"
        case contentTypeFull = "contentTypeFull"
        case contentTypeCompressed = "contentTypeCompressed"
        case contentName = "contentName"
        case previewName = "previewName"
    }
    
    public var id: String
    public var contentUrl: String
    public var previewUrl: String
    public var contentTypeFull: String
    public var contentTypeCompressed: String
    public var contentName: String
    public var previewName: String
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(contentUrl, forKey: .contentUrl)
        try container.encode(previewUrl, forKey: .previewUrl)
        try container.encode(contentTypeFull, forKey: .contentTypeFull)
        try container.encode(contentTypeCompressed, forKey: .contentTypeCompressed)
        try container.encode(contentName, forKey: .contentName)
        try container.encode(previewName, forKey: .previewName)
    }
}

/*
 {
   "items": [
     {
       "id": "4c02014c-974d-4db1-8513-ea18c13b31b8",
       "description": "Trololo",
       "visibility": 1,
       "publicationDate": "0001-01-01T00:00:00",
       "contents": [
         {
           "id": "105f1f23-3c71-45a4-8c59-13bf8ff3ef44",
           "contentUrl": "https://storage.googleapis.com/download/storage/v1/b/you360-bucket/o/Post%2FContent%2FImage%2FContent%2F105f1f23-3c71-45a4-8c59-13bf8ff3ef44?generation=1715598804925922&alt=media",
           "previewUrl": "https://storage.googleapis.com/download/storage/v1/b/you360-bucket/o/Post%2FContent%2FImage%2FPreview%2F105f1f23-3c71-45a4-8c59-13bf8ff3ef44?generation=1715598805156460&alt=media",
           "contentTypeFull": "image/png",
           "contentTypeCompressed": "image/jpeg",
           "contentName": "Post/Content/Image/Content/105f1f23-3c71-45a4-8c59-13bf8ff3ef44",
           "previewName": "Post/Content/Image/Preview/105f1f23-3c71-45a4-8c59-13bf8ff3ef44"
         }
       ],
       "userAuthor": {
         "id": "f72d4638-43ff-49f5-bae5-dd0d769398f1",
         "email": null,
         "userName": null,
         "name": "Andy",
         "surname": null,
         "aboutMe": null,
         "dateOfBirth": null,
         "city": null,
         "paymentMethod": null,
         "instagram": null,
         "facebook": null,
         "twitter": null,
         "postsCount": 0,
         "ticketsCount": 0,
         "likedEventsCount": 0,
         "establishmentsSubscriptionsCount": 0,
         "reservationsCount": 0,
         "avatar": null,
         "avatarId": null,
         "background": null,
         "backgroundId": null,
         "verification": 0,
         "establishmentId": null
       },
       "userAuthorId": "f72d4638-43ff-49f5-bae5-dd0d769398f1",
       "establishmentAuthor": null,
       "establishmentAuthorId": null,
       "likesCount": 0,
       "commentsCount": 0
     }
   ],
   "offset": 0,
   "size": 100,
   "totalCount": 1,
   "hasNextItem": false,
   "hasPreviousItem": false
 }

 */

public final class ProfileContentPage: Codable {
    private enum CodingKeys : String, CodingKey {
        case items = "items"
        case offset = "offset"
        case size = "size"
        case totalCount = "totalCount"
        case hasNextItem = "hasNextItem"
        case hasPreviousItem = "hasPreviousItem"
    }
    
    public var items: [ProfileContent]
    public var offset: Int
    public var size: Int
    public var totalCount: Int
    public var hasNextItem: Bool
    public var hasPreviousItem: Bool
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
        try container.encode(offset, forKey: .offset)
        try container.encode(size, forKey: .size)
        try container.encode(totalCount, forKey: .totalCount)
        try container.encode(hasNextItem, forKey: .hasNextItem)
        try container.encode(hasPreviousItem, forKey: .hasPreviousItem)
    }
}
