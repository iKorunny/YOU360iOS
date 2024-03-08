//
//  LoginButtonsCell.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/24/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class LoginButtonsCell: UITableViewCell {
    
    private enum Constants {
        static let loginTitleSize: CGFloat = 16
        static let forgotPasswordTitleSize: CGFloat = 14
        
        static let buttonsHorizontalPadding: CGFloat = 20
        static let loginButtonTopPadding: CGFloat = 24
        static let forgotPasswordButtonTopPadding: CGFloat = 16
        static let forgotPasswordButtonBottomPadding: CGFloat = 16
    }
    
    private var loginAction: (() -> Void)?
    private var forgotPasswordAction: (() -> Void)?
    
    private lazy var loginButton: UIButton = {
        let button = ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appPink,
            highlightedBackgroundColor: ColorPallete.appDarkPink,
            title: "LoginButtonTitle".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.loginTitleSize),
            titleColor: ColorPallete.appWhite,
            titleIcon: UIImage(named: "LoginRightArrow"),
            titleIconAligment: .right,
            target: self,
            action: #selector(login)
        )
        
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appWhiteSecondary,
            highlightedBackgroundColor: ColorPallete.appDarkWhite,
            title: "LoginForgotPasswordButtonTitle".localised(),
            titleFont: YOUFontsProvider.appSemiBoldFont(with: Constants.forgotPasswordTitleSize),
            titleColor: ColorPallete.appDarkGrey,
            target: self,
            action: #selector(forgotPassword)
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
    
    func setup(with loginAction: @escaping (() -> Void), forgotPasswordAction: @escaping (() -> Void)) {
        self.loginAction = loginAction
        self.forgotPasswordAction = forgotPasswordAction
    }
    
    private func setupUI() {
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        selectionStyle = .none
        
        contentView.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.loginButtonTopPadding).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.buttonsHorizontalPadding).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.buttonsHorizontalPadding).isActive = true
        
        contentView.addSubview(forgotPasswordButton)
        forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Constants.forgotPasswordButtonTopPadding).isActive = true
        forgotPasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.buttonsHorizontalPadding).isActive = true
        forgotPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.buttonsHorizontalPadding).isActive = true
        forgotPasswordButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.forgotPasswordButtonBottomPadding).isActive = true
    }
    
    @objc private func login() {
        loginAction?()
    }
    
    @objc private func forgotPassword() {
        forgotPasswordAction?()
    }
}
