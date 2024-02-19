//
//  LocalisedImageProvider.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 2/19/24.
//

import Foundation
import UIKit

public final class LocalisedImageProvider {
    public static func localisedImage(with name: String) -> UIImage? {
        let currentLocale = Locale.current
        switch currentLocale.identifier {
        case _ where currentLocale.identifier.contains("ru_"):
            return UIImage(named: name.appending("_ru"))
        default:
            return UIImage(named: name)
        }
    }
}
