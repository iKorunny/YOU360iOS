//
//  UIImage+Extension.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 3/17/24.
//

import Foundation
import UIKit

public extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return image.withRenderingMode(renderingMode)
    }
    
    func embed(with text: String,
               color: UIColor,
               imageAlignment: Int = 0,
               textFont: UIFont = YOUFontsProvider.appMediumFont(with: 14),
               textOffset: CGFloat = 4) -> UIImage {
        let font = textFont
        let expectedTextSize: CGSize = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        let width: CGFloat = expectedTextSize.width + size.width + textOffset
        let height: CGFloat = max(expectedTextSize.height, size.width)
        let newSize: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.setStrokeColor(color.cgColor)
        color.setFill()
        let fontTopPosition: CGFloat = (height - expectedTextSize.height) / 2.0
        let textOrigin: CGFloat = (imageAlignment == 0) ? size.width + textOffset : 0
        let textPoint: CGPoint = CGPoint.init(x: textOrigin, y: fontTopPosition)
        text.draw(at: textPoint, withAttributes: [
            NSAttributedString.Key.font: font,
            .foregroundColor: color
        ])
        let flipVertical: CGAffineTransform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        context.concatenate(flipVertical)
        let alignment: CGFloat = (imageAlignment == 0) ? 0.0 : expectedTextSize.width + textOffset
        context.draw(cgImage!, in: CGRect(x: alignment, y: ((height - newSize.height) / 2.0), width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func image(with color: UIColor) -> UIImage? {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
