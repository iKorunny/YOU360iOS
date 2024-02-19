//
//  LoginStartVC.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/18/24.
//

import UIKit
import YOUUIComponents
import YOUUtils

final class LoginStartVC: UIViewController {
    
    private enum Constants {
        static let logoViewSize = CGSize(width: 123, height: 41)
        static let logoInsets = UIEdgeInsets(top: 65, left: 0, bottom: 0, right: 21)
        
        static let createAccountButtonInsets = UIEdgeInsets(top: 16, left: 20, bottom: 58, right: 20)
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "LOGOYOU360"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var createAccountButton: UIButton = {
        return ButtonsFactory.createWideButton(
            backgroundColor: ColorPallete.appPink,
            title: "ButtonCreateAccountTitle".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: 16),
            titleColor: ColorPallete.appWhite,
            titleIcon: UIImage(named: "CreateAccountIcon"),
            titleIconAligment: .right,
            target: self,
            action: #selector(createAccount),
            for: .touchUpInside
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        logoImageView.heightAnchor.constraint(equalToConstant: Constants.logoViewSize.height).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: Constants.logoViewSize.width).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.logoInsets.top).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.logoInsets.right).isActive = true
        
        view.addSubview(createAccountButton)
        createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.createAccountButtonInsets.left).isActive = true
        createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.createAccountButtonInsets.right).isActive = true
        createAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.createAccountButtonInsets.bottom).isActive = true
    }
    
    @objc private func createAccount() {
        print()
    }
}
