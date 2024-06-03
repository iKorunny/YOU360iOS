//
//  UIView+Copy.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 6/3/24.
//

import Foundation
import UIKit

public extension UIView {
    func copyView<T: UIView>() -> T? {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false) else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data)
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
