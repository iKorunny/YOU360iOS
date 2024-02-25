//
//  SignInButtonsCell.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/25/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class SignInButtonsCell: UITableViewCell {
    
    private enum Constants {
        static let buttonTitleSize: CGFloat = 16
        
        static let buttonHorizontalPadding: CGFloat = 20
        static let buttonTopPadding: CGFloat = 24
        static let buttonBottomPadding: CGFloat = 16
    }
    
    private var signInAction: (() -> Void)?
    
    private lazy var signInButton: UIButton = {
        let button = ButtonsFactory.createWideButton(
            backgroundColor: ColorPallete.appPink,
            highlightedBackgroundColor: ColorPallete.appDarkPink,
            title: "RegisterButtonTitle".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.buttonTitleSize),
            titleColor: ColorPallete.appWhite,
            titleIcon: UIImage(named: "LoginRightArrow"),
            titleIconAligment: .right,
            target: self,
            action: #selector(signIn)
        )
        
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with signInAction: @escaping (() -> Void)) {
        self.signInAction = signInAction
    }
    
    private func setupUI() {
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        selectionStyle = .none
        
        contentView.addSubview(signInButton)
        signInButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.buttonTopPadding).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.buttonHorizontalPadding).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.buttonHorizontalPadding).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.buttonBottomPadding).isActive = true
    }
    
    @objc private func signIn() {
        signInAction?()
    }
}
