//
//  Formatters.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 3/18/24.
//

import Foundation

public class Formatters {
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
}
