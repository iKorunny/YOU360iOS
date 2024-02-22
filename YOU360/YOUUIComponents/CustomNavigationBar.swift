//
//  CustomNavigationBar.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/22/24.
//

import UIKit

public final class CustomNavigationBar: UIView {
    private enum Constants {
        static let barContentHeight: CGFloat = 44
        static let barContentTopOffset: CGFloat = 46
        
        static let logoViewSize = CGSize(width: 75, height: 25)
        static let logoInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18)
        
        static let backButtonPadding: CGFloat = 18
    }
    
    private var setupComplete = false
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: Constants.barContentHeight).isActive = true
        return view
    }()
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "LOGOYOU360"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: Constants.logoViewSize.height).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.logoViewSize.width).isActive = true
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(named: "NavigationBack"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public override var backgroundColor: UIColor? {
        didSet {
            contentView.backgroundColor = backgroundColor
        }
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard !setupComplete else { return }
        setupUI()
        setupComplete = true
    }
    
    public func setBackButton(target: Any?, selector: Selector, for event: UIControl.Event) {
        backButton.addTarget(target, action: selector, for: event)
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.barContentTopOffset).isActive = true
        
        contentView.addSubview(logoView)
        logoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.logoInsets.right).isActive = true
        logoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(backButton)
        backButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.backButtonPadding).isActive = true
    }
}
