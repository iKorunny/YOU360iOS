//
//  SubscriptionResponse.swift
//  YOUNetworking
//
//  Created by Andrei Tamila on 5/14/24.
//

import Foundation

public final class SubscriptionResponse: Decodable {
    public let id: String
    public let startDate: String
    public let endDate: String
    public let establishmentId: String
}
