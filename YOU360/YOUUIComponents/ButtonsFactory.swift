//
//  ButtonsFactory.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import UIKit

public enum ButtonsFactoryDefaults {
    public static let wideButtonDefaultHeight: CGFloat = 56
    public static let wideButtonDefaultCornerRadius: CGFloat = 12
    public static let wideButtonDefaultTitleFontSize: CGFloat = 16
}

public enum ButtonsFactoryTitleIconAligment {
    case left
    case right
}

public final class ButtonsFactory {
    
    public func createWideButton(
        backgroundColor: UIColor = .clear,
        title: String? = nil,
        titleFont: UIFont = .systemFont(ofSize: ButtonsFactoryDefaults.wideButtonDefaultTitleFontSize),
        titleColor: UIColor? = nil,
        titleIcon: UIImage? = nil,
        titleIconAligment: ButtonsFactoryTitleIconAligment = .left,
        height: CGFloat = ButtonsFactoryDefaults.wideButtonDefaultHeight,
        cornerRadius: CGFloat = ButtonsFactoryDefaults.wideButtonDefaultCornerRadius
    ) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = backgroundColor
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = titleFont
        button.setTitleColor(titleColor, for: .normal)
        button.setImage(titleIcon, for: .normal)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = cornerRadius
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return button
    }
}
