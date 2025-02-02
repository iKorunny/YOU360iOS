//
//  ButtonsFactory.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import UIKit
import YOUUtils

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
    
    public static func createIconButton(
        icon: UIImage?,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0,
        highlightColor: UIColor? = nil,
        target: Any? = nil,
        action: Selector? = nil,
        for event: UIControl.Event = .touchUpInside
    ) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = backgroundColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = cornerRadius
        
        if let newTintColor = highlightColor {
            button.tintColor = newTintColor
        }
        
        button.setImage(icon, for: .normal)
        if let action = action {
            button.addTarget(target, action: action, for: event)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    public static func createTextButton(
        title: String?,
        titleFont: UIFont,
        titleColor: UIColor,
        highLightedTitleColor: UIColor? = nil,
        target: Any? = nil,
        action: Selector? = nil,
        for event: UIControl.Event = .touchUpInside
    ) -> UIButton {
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        if let action = action {
            button.addTarget(target, action: action, for: event)
        }
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(highLightedTitleColor ?? titleColor, for: .highlighted)
        button.setTitleColor(highLightedTitleColor ?? titleColor, for: .selected)
        button.titleLabel?.font = titleFont
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    public static func createButton(
        backgroundColor: UIColor = .clear,
        highlightedBackgroundColor: UIColor = .clear,
        title: String? = nil,
        titleFont: UIFont = YOUFontsProvider.appBoldFont(with: ButtonsFactoryDefaults.wideButtonDefaultTitleFontSize),
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
        configuration.imageColorTransformer = UIConfigurationColorTransformer { [weak button] color in
            button?.backgroundColor = (button?.state == .selected || button?.state == .highlighted) ? highlightedBackgroundColor : backgroundColor
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
    
    public static func createButtonDisablingGestures(
        backgroundColor: UIColor = .clear,
        highlightedBackgroundColor: UIColor = .clear,
        title: String? = nil,
        titleFont: UIFont = YOUFontsProvider.appBoldFont(with: ButtonsFactoryDefaults.wideButtonDefaultTitleFontSize),
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
    ) -> ButtonDisablingGestures {
        let button = ButtonDisablingGestures()
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = iconPadding
        configuration.image = titleIcon
        configuration.imageColorTransformer = UIConfigurationColorTransformer { [weak button] color in
            button?.backgroundColor = (button?.state == .selected || button?.state == .highlighted) ? highlightedBackgroundColor : backgroundColor
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
