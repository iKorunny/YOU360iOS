//
//  ProfileVC.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/1/24.
//

import UIKit
import YOUUtils

final class ProfileVC: UIViewController {
    
    private enum Constants {
        static let backButtonInsets = UIEdgeInsets(top: 52, left: 20, bottom: 0, right: 0)
        static let moreButtonInsets = UIEdgeInsets(top: 52, left: 0, bottom: 0, right: 20)
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NavigationBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ProfileMenu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(toMore), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
        
        view.addSubview(moreButton)
        moreButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.moreButtonInsets.top).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.moreButtonInsets.right).isActive = true
    }
    
    @objc private func popBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toMore() {
        print("ProfileVC -> to More")
    }
}

extension ProfileVC: UIGestureRecognizerDelegate {
    
}
