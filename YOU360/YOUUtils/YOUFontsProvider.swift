//
//  YOUFontsProvider.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 2/19/24.
//

import Foundation
import UIKit

public final class YOUFontsProvider {
    public static func appRegularFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Manrope-Regular", size: size)!
    }
    
    public static func appBoldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Manrope-Bold", size: size)!
    }
}
