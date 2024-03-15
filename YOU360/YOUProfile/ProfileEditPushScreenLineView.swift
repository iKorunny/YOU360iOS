//
//  ProfileEditPushScreenLineView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/15/24.
//

import UIKit
import YOUUtils

final class ProfileEditPushScreenLineView: UIView {
    deinit {
        button.removeTarget(self, action: #selector(highlight), for: .touchDragInside)
        button.removeTarget(self, action: #selector(highlight), for: .touchDown)
        button.removeTarget(self, action: #selector(unHighlight), for: .touchDragOutside)
        button.removeTarget(self, action: #selector(unHighlight), for: .touchCancel)
        button.removeTarget(self, action: #selector(playAction), for: .touchUpInside)
    }
    
    private enum Constants {
        static let contentOffset: CGFloat = 16
    }
    
    var model: ProfileEditPushScreenLineModel?
    
    private(set) lazy var rightIconView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "CellOpenScreenIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var button: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(highlight), for: .touchDragInside)
        button.addTarget(self, action: #selector(highlight), for: .touchDown)
        button.addTarget(self, action: #selector(unHighlight), for: .touchDragOutside)
        button.addTarget(self, action: #selector(unHighlight), for: .touchCancel)
        button.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    convenience init(model: ProfileEditPushScreenLineModel) {
        self.init(frame: .zero, model: model)
    }
    
    init(frame: CGRect, model: ProfileEditPushScreenLineModel) {
        super.init(frame: frame)
        self.model = model
        didLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didLoad() {
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = ColorPallete.appWhite
        
        addSubview(rightIconView)
        rightIconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentOffset).isActive = true
        rightIconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(textLabel)
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentOffset).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: rightIconView.leadingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        if let model = model {
            apply(model: model)
        }
        
        addSubview(button)
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func apply(model: ProfileEditPushScreenLineModel) {
        if let text = model.text {
            textLabel.text = text
            textLabel.font = model.textFont
            textLabel.textColor = model.textColor
        }
        else {
            textLabel.text = model.placeholder
            textLabel.font = model.placeholderFont
            textLabel.textColor = model.placeholderColor
        }
    }
    
    @objc private func highlight() {
        backgroundColor = ColorPallete.appDarkWhite
    }
    
    @objc private func unHighlight() {
        backgroundColor = ColorPallete.appWhite
    }
    
    @objc private func playAction() {
        unHighlight()
        model?.action()
    }
}
