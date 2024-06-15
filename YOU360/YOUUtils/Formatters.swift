//
//  Formatters.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 3/18/24.
//

import Foundation
import Contacts

public final class Formatters {
    public static let dateOfBirthNetworkFormatter = DateOfBirthNetworkFormatter()
    
    public static func formateDayMonthYear(date: Date?) -> String? {
        guard let date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    public static func dateFromString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.date(from: string)
    }
    
    public static func dateFromISO8601String(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string)
    }
    
    public static func ageFrom(birthdate: Date) -> String? {
        let now = Date()
        let birthday: Date = birthdate
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        guard let age = ageComponents.year else { return nil }
        return "\(age)"
    }
    
    public static func formatFullName(firstName: String?, lastName: String?) -> String? {
        let formatter = PersonNameComponentsFormatter()
        let components = PersonNameComponents(namePrefix: nil,
                                              givenName: firstName,
                                              middleName: nil,
                                              familyName: lastName,
                                              nameSuffix: nil,
                                              nickname: nil,
                                              phoneticRepresentation: nil)
        
        return formatter.string(from: components)
    }
    
    public static func formatEvent(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY"
        return formatter.string(from: date)
    }
    
    public static func formatEventPrice(amount: CGFloat, currencySymbol: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.currencySymbol = currencySymbol
        return formatter.string(from: NSNumber(value: amount))
    }
    
    public static func formatEventPrice(amount: CGFloat, currencyCode: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.currencyCode = currencyCode
        return formatter.string(from: NSNumber(value: amount))
    }
    
    public static func formatShortForm(of value: Int) -> String? {
        if value >= 1000, value <= 999999 {
            return "\(Int(floor(Double(value / 1000))))K"
        }
        
        if value > 999999 {
            return "\(Int(floor(Double(value / 1000000))))M"
        }
        
        return "\(value)"
    }
}

public final class DateOfBirthNetworkFormatter {
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    public func toString(date: Date?) -> String? {
        guard let date = date else { return nil }
        return dateFormatter.string(from: date)
    }
    
    public func toDate(string: String?) -> Date? {
        guard let string = string else { return nil }
        return dateFormatter.date(from: string)
    }
}

public final class AddressFormatter {
    public static func format(country: String?,
                              region: String?,
                              city: String?,
                              street: String?,
                              zipCode: String?) -> String? {
        let address = CNMutablePostalAddress()
        if let country {
            address.country = country
        }
        
        if let region {
            address.state = region
        }
        
        if let city {
            address.city = city
        }
        
        if let street {
            address.street = street
        }
        
        if let zipCode {
            address.postalCode = zipCode
        }
        
        return CNPostalAddressFormatter.string(from: address, style: .mailingAddress)
    }
}
