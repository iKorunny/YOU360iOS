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
}
