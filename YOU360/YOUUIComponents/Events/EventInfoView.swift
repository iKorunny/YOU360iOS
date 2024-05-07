//
//  EventInfoView.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 4/29/24.
//

import UIKit
import YOUUtils

public enum EventInfoViewType {
    case date
    case price
    
    func icon() -> UIImage? {
        switch self {
        case .date:
            return UIImage(named: "EventDateIcon")
        case .price:
            return UIImage(named: "EventPriceIcon")
        }
    }
}

public final class EventInfoView: UIView {
    private enum Constants {
        static let iconInsets = UIEdgeInsets(top: 8, left: 12, bottom: -8, right: -8)
        static let labelRightInset: CGFloat = -12
        static let labelFontSize: CGFloat = 14
        
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 12
    }
    
    public static func create(with type: EventInfoViewType, text: String?) -> EventInfoView {
        let view = EventInfoView()
        view.setupUI(with: type, text: text)
        return view
    }
    
    public static func create() -> EventInfoView {
        let view = EventInfoView()
        return view
    }
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPallete.appWhite3
        label.numberOfLines = 1
        label.font = YOUFontsProvider.appBoldFont(with: Constants.labelFontSize)
        return label
    }()
    
    public func set(type: EventInfoViewType, text: String?) {
        set(text: text)
        iconView.image = type.icon()
    }
    
    public func set(text: String?) {
        textLabel.text = text
    }
    
    private func setupUI(with type: EventInfoViewType, text: String?) {
        iconView.image = type.icon()
        addSubview(iconView)
        
        iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.iconInsets.left).isActive = true
        iconView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.iconInsets.top).isActive = true
        iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.iconInsets.bottom).isActive = true
        
        textLabel.text = text
        addSubview(textLabel)
        iconView.trailingAnchor.constraint(equalTo: textLabel.leadingAnchor, constant: Constants.iconInsets.right).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.labelRightInset).isActive = true
        
        layer.masksToBounds = true
        layer.borderWidth = Constants.borderWidth
        layer.cornerRadius = Constants.cornerRadius
        
        updateColors()
    }
    
    private func updateColors() {
        textLabel.textColor = ColorPallete.appWhite3
        backgroundColor = ColorPallete.appPink
        layer.borderColor = ColorPallete.appWhite4.cgColor
    }
}
