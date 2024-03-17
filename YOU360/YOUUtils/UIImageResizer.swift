//
//  UIImageResizer.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 3/17/24.
//

import Foundation
import UIKit

public final class UIImageResizer {
    public static func resizeTo1080p(image: UIImage) -> UIImage {
        let targetSize: CGSize = .init(width: 1920, height: 1080)
        return resize(image: image, to: targetSize)
    }
    
    public static func resizeTo720p(image: UIImage) -> UIImage {
        let targetSize: CGSize = .init(width: 1280, height: 720)
        return resize(image: image, to: targetSize)
    }
    
    public static func resize(image: UIImage, to targetSize: CGSize) -> UIImage {
        let scaleFactor = max(image.size.width / targetSize.width,
                              image.size.height / targetSize.height)
        guard scaleFactor > 1 else { return image }
        
        return image.imageWith(newSize: CGSize(width: image.size.width / scaleFactor,
                                               height: image.size.height / scaleFactor))
    }
}
