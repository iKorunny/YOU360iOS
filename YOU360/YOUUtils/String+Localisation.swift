//
//  String+Localisation.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 2/19/24.
//

import Foundation

public extension String {
    func localised(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
