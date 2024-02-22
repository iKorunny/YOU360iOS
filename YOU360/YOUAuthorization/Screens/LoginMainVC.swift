//
//  LoginMainVC.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/20/24.
//

import UIKit
import YOUUIComponents
import YOUUtils

class LoginMainVC: CustomNavigationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ButtonLoginTitle".localised()
        
        setupUI()
    }
    
    private func setupUI() {
//        let field = TextFieldWithError()
//        field.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(field)
//        field.widthAnchor.constraint(equalToConstant: 355).isActive = true
//        field.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let roundedView = TopRoundedView()
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.backgroundColor = .clear
        roundedView.fillColor = ColorPallete.appWhiteSecondary
        roundedView.widthAnchor.constraint(equalToConstant: 355).isActive = true
        roundedView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        view.addSubview(roundedView)
        roundedView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        roundedView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
