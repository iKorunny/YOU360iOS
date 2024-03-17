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
}
