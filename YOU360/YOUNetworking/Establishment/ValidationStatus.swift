//
//  ValidationStatus.swift
//  YOUNetworking
//
//  Created by Andrei Tamila on 5/13/24.
//

import Foundation

public enum ValidationStatus: Decodable {
    case inProgress
    case needAction
    case rejected
    case verified
}
