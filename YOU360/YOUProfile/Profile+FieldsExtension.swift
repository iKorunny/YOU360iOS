//
//  Profile+FieldsExtension.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 4/8/24.
//

import Foundation
import YOUProfileInterfaces
import YOUUtils

extension Profile {
    var displayName: String {
        return Formatters.formatFullName(firstName: name, lastName: surname) ?? userName ?? ""
    }
    
    var isVerified: Bool {
        return verification == .verified
    }
    
    var birthDate: Date? {
        return Formatters.dateOfBirthNetworkFormatter.toDate(string: dateOfBirth)
    }
    
    var hasSocial: Bool {
        if let instagram, let _ = URL(string: instagram) {
            return true
        }
        if let facebook, let _ = URL(string: facebook) {
            return true
        }
        if let twitter, let _ = URL(string: twitter) {
            return true
        }
        return false
    }
}
