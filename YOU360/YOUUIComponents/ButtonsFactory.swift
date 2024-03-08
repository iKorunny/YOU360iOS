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
    public static let wideButtonDefaultIconPadding: CGFloat = 8
    
    public static let wideButtonDefaultHighlightedAlpha: CGFloat = 0.4
}

public enum ButtonsFactoryTitleIconAligment {
    case left
    case right
}

public final class ButtonsFactory {
    
    public static func createButton(
        backgroundColor: UIColor = .clear,
        highlightedBackgroundColor: UIColor = .clear,
        title: String? = nil,
        titleFont: UIFont = .systemFont(ofSize: ButtonsFactoryDefaults.wideButtonDefaultTitleFontSize),
        titleColor: UIColor? = nil,
        titleIcon: UIImage? = nil,
        contentInsets: NSDirectionalEdgeInsets? = nil,
        iconPadding: CGFloat = ButtonsFactoryDefaults.wideButtonDefaultIconPadding,
        titleIconAligment: ButtonsFactoryTitleIconAligment = .left,
        height: CGFloat = ButtonsFactoryDefaults.wideButtonDefaultHeight,
        cornerRadius: CGFloat = ButtonsFactoryDefaults.wideButtonDefaultCornerRadius,
        target: Any? = nil,
        action: Selector? = nil,
        for event: UIControl.Event = .touchUpInside
    ) -> UIButton {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = iconPadding
        configuration.image = titleIcon
        configuration.imageColorTransformer = UIConfigurationColorTransformer { color in
            return titleColor ?? .clear
        }
        if let contentInsets {
            configuration.contentInsets = contentInsets
        }
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { [weak button] incoming in
            var outgoing = incoming
            outgoing.foregroundColor = titleColor
            button?.backgroundColor = (button?.state == .selected || button?.state == .highlighted) ? highlightedBackgroundColor : backgroundColor
            return outgoing
        }
        
        switch titleIconAligment {
        case .right:
            configuration.imagePlacement = .trailing
        default:
            break
        }
        button.configuration = configuration
        
        button.backgroundColor = backgroundColor
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = titleFont
        button.setTitleColor(titleColor, for: .normal)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = cornerRadius
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        if let action = action {
            button.addTarget(target, action: action, for: event)
        }
        
        return button
    }
}
