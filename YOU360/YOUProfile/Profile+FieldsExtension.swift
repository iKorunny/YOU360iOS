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
        var result: String?
        
        if let name {
            result = name
        }
        
        if let surname {
            if result != nil {
                result! +=  " " + surname
            }
            else {
                result = surname
            }
        }
        
        return result ?? userName
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
