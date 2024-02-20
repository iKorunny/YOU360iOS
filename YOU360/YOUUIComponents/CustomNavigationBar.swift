//
//  CustomNavigationBar.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/20/24.
//

import UIKit
import YOUUtils

public final class CustomNavigationBar: UIView {
    private enum Constants {
        static let logoViewSize = CGSize(width: 123, height: 41)
        static let logoInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18)
        
        static let titleFontSize: CGFloat = 18
        static let titleMinimunOffset: CGFloat = 5
        static let backButtonLeading: CGFloat = 10
    }
    
    private var setupComplete: Bool = false
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "LOGOYOU360"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = YOUFontsProvider.appSemiBoldFont(with: Constants.titleFontSize)
        label.textColor = ColorPallete.appBlackSecondary
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "NavigationBack"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard !setupComplete else { return }
        setupUI()
        setupComplete = true
    }
    
    public func setBackButton(hidden: Bool) {
        backButton.isHidden = hidden
    }
    
    public func setBackButton(target: Any? = nil,
                              action: Selector,
                              for event: UIControl.Event) {
        backButton.addTarget(target, action: action, for: event)
    }
    
    public func set(title: String?) {
        titleLabel.text = title
    }
    
    private func setupUI() {
        addSubview(logoImageView)
        logoImageView.heightAnchor.constraint(equalToConstant: Constants.logoViewSize.height).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: Constants.logoViewSize.width).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.logoInsets.right).isActive = true
        
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: logoImageView.leadingAnchor, constant: Constants.titleMinimunOffset).isActive = true
        
        addSubview(backButton)
        backButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.backButtonLeading).isActive = true
    }
}
