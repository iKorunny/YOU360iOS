//
//  TextSizeCalculator.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 3/9/24.
//

import Foundation
import UIKit

public final class TextSizeCalculator {
    public static func calculateSize(with width: CGFloat, text: String, font: UIFont) -> CGSize {
        let calculated = (text as NSString).boundingRect(with: CGSize(width: width, height: 0), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return calculated.size
    }
}
