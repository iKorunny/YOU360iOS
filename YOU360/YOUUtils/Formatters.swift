//
//  Formatters.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 3/18/24.
//

import Foundation

public final class Formatters {
    public static let dateOfBirthNetworkFormatter = DateOfBirthNetworkFormatter()
    
    public static func formateDayMonthYear(date: Date?) -> String? {
        guard let date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
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
        var components = PersonNameComponents(namePrefix: nil,
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
        formatter.dateFormat = "dd.mm.yy"
        return formatter.string(from: date)
    }
    
    public static func formatEventPrice(amount: CGFloat, currencySymbol: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.currencySymbol = currencySymbol
        return formatter.string(from: NSNumber(value: amount))
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
