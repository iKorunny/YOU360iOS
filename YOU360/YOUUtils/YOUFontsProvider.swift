//
//  YOUFontsProvider.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 2/19/24.
//

import Foundation
import UIKit

public final class YOUFontsProvider {
    /**
     size = 400
     */
    public static func appRegularFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Manrope-Regular", size: size)!
    }
    
    /**
     size = 600
     */
    public static func appSemiBoldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Manrope-SemiBold", size: size)!
    }
    
    /**
     size = 700
     */
    public static func appBoldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: "Manrope-Bold", size: size)!
    }
}
