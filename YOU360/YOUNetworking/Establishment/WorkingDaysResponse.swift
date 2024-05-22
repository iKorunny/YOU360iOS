//
//  WorkingDayResponse.swift
//  YOUNetworking
//
//  Created by Andrei Tamila on 5/14/24.
//

import Foundation

public final class WorkingDayResponse: Decodable {
    let id: String
    let dayOfWeek: Int
    let openingTime: String
    let closingTime: String
    let establishmentId: String
}
