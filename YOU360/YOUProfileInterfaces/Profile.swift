//
//  Profile.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 3/1/24.
//

import Foundation
public final class Profile: Codable {
    private enum CodingKeys : String, CodingKey {
        case email = "email"
    }
    
    var email: String?
    
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
    }
}
