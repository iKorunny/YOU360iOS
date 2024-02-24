//
//  LoginSocialNetworksCell.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/24/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class LoginSocialNetworksCell: UITableViewCell {
    private enum Constants {
        static let firstButtonTopOffset: CGFloat = 28
        static let buttonHorizontalPadding: CGFloat = 20
        static let verticalButtonsSpacing: CGFloat = 12
        static let lastButtonBottomOffset: CGFloat = 53
        static let buttonTextSize: CGFloat = 16
    }
    
    private var action: ((LoginSocialNetwork) -> Void)?
    private var networks: [LoginSocialNetwork] = []
    
    private lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = ColorPallete.appWhiteSecondary
        container.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = container.heightAnchor.constraint(equalToConstant: CGFloat.leastNonzeroMagnitude)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        return container
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        setupButtons()
    }
    
    func setup(with networks: [LoginSocialNetwork], action: @escaping ((LoginSocialNetwork) -> Void)) {
        self.action = action
        self.networks = networks
        setupButtons()
    }
    
    private func setupButtons() {
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        guard !networks.isEmpty else { return }
        
        var previousButton: UIView?
        networks.forEach { [weak self] network in
            guard let self = self,
                  let first = self.networks.first,
                    let last = self.networks.last else { return }
            let isFirst = network.rawValue == first.rawValue
            let isLast = network.rawValue == last.rawValue
            
            let button = createButton(for: network)
            self.containerView.addSubview(button)
            if isFirst {
                button.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: Constants.firstButtonTopOffset).isActive = true
            }
            else if let previousButton = previousButton {
                button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: Constants.verticalButtonsSpacing).isActive = true
            }
            
            button.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: Constants.buttonHorizontalPadding).isActive = true
            button.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -Constants.buttonHorizontalPadding).isActive = true
            
            if isLast {
                button.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -Constants.lastButtonBottomOffset).isActive = true
            }
            
            previousButton = button
        }
    }
    
    private func createButton(for network: LoginSocialNetwork) -> UIButton {
        let button = ButtonsFactory.createWideButton(
            backgroundColor: ColorPallete.appWhite,
            highlightedBackgroundColor: ColorPallete.appDarkWhite,
            title: String(format: "LoginSocialAuth".localised(), network.rawValue),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.buttonTextSize),
            titleColor: ColorPallete.appBlackSecondary,
            titleIcon: network.logoImage(),
            target: self,
            action: #selector(buttonAction(sender:))
        )
        
        if let index = networks.firstIndex(of: network) {
            button.tag = index
        }
        
        return button
    }
    
    @objc private func buttonAction(sender: UIView) {
        let index = sender.tag
        guard index < networks.count else { return }
        let network = networks[index]
        action?(network)
    }
}
