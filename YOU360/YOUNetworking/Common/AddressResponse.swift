//
//  AddressResponse.swift
//  YOUNetworking
//
//  Created by Andrei Tamila on 5/14/24.
//

import Foundation

public final class AddressResponse: Decodable {
    public let id: String
    public let latitude: Double
    public let longitude: Double
    public let country: String?
    public let region: String?
    public let city: String?
    public let street: String?
    public let zipCode: String?
    public let houseNumber: String?
}
