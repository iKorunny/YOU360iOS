//
//  Establishment.swift
//  YOUNetworking
//
//  Created by Andrei Tamila on 5/13/24.
//

import Foundation

/*
 public record EstablishmentResponse
 {
     public Guid Id { get; init; }
     public Uri? WebsiteUrl { get; init; }
     public Uri? Instagram { get; init; }
     public Uri? Facebook { get; init; }
     public Uri? Twitter { get; init; }

     public string Name { get; init; } = null!;
     public string? Description { get; init; }
     public EstablishmentCategory Category { get; init; }
     public string? PhoneNumber { get; init; }
     public string? PlaceAddress { get; init; }

     public ContentResponse? Background { get; init; }
     public Guid? BackgroundId { get; set; }
     public ContentResponse? Avatar { get; init; }
     public Guid? AvatarId { get; set; }
     
     public Guid UserId { get; init; }
     public SubscriptionResponse? Subscription { get; init; }
     public AddressResponse? Address { get; init; }
     public List<WorkingDayResponse> WorkingDays { get; init; } = new();
     public int EventsCount { get; init; }
     public int SubscribersCount { get; init; }
     public int PostsCount { get; init; }
     public int TablesCount { get; init; }
     public int MenusCount { get; init; }
     public int CertificatesCount { get; init; }
 }
 */

public final class EstablishmentResponse: Codable {
    public var id: String
    public var websiteUrl: String?
    public var instagram: String?
    public var facebook: String?
    public var twitter: String?

    public var name: String?
    public var description: String?
    public var category: EstablishmentCategory
    public var phoneNumber: String?
    public var placeAddress: String?
    
    public var avatar: ContentResponse?
    public var avatarId: String?
    public var background: ContentResponse?
    public var backgroundId: String?

    public var userId: String
    public var postsCount: Int
    public var ticketsCount: Int
    public var likedEventsCount: Int
    public var establishmentsSubscriptionsCount: Int
    public var reservationsCount: Int

    public var verification: ProfileVerification
    public var establishmentId: String?
    
}
