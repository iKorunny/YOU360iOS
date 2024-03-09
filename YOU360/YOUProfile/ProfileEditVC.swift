//
//  ProfileEditVC.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/9/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class ProfileEditVC: UIViewController {
    
    private enum Constants {
        static let backButtonInsets = UIEdgeInsets(top: 52, left: 20, bottom: 0, right: 0)
        static let saveButtonInsets = UIEdgeInsets(top: 52, left: 0, bottom: 0, right: 20)
        static let saveButtonFontSize: CGFloat = 18
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NavigationBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = ButtonsFactory.createTextButton(
            title: "ProfileEditVCSaveButton".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.saveButtonFontSize),
            titleColor: ColorPallete.appPink,
            highLightedTitleColor: ColorPallete.appDarkPink,
            target: self,
            action: #selector(onSave),
            for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorPallete.appWhiteSecondary
        setupUI()
    }
    
    private func setupUI() {
        
        setupTopButtons()
    }
    
    private func setupTopButtons() {
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.backButtonInsets.left).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.backButtonInsets.top).isActive = true
        backButton.isHidden = ((navigationController?.viewControllers ?? []).count == 1 || navigationController?.visibleViewController !== self)
        
        view.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.saveButtonInsets.top).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.saveButtonInsets.right).isActive = true
    }
    
    @objc private func popBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onSave() {
        print("ProfileEditVC -> onSave")
    }
}
