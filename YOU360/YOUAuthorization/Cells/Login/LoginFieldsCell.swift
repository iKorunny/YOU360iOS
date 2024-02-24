//
//  LoginFieldsCell.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/23/24.
//

import UIKit
import YOUUIComponents
import YOUUtils

final class LoginFieldsCellModel {
    var loginFieldState: TextFieldWithError.State = .default
    var passwordFieldState: TextFieldWithError.State = .default
}

final class LoginFieldsCell: UITableViewCell {
    private enum Constants {
        static let fieldsPadding: CGFloat = 20
        static let loginTopOffset: CGFloat = 16
        static let fieldsVerticalPadding: CGFloat = 24
    }
    
    lazy var loginField = {
        let field = TextFieldWithError()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.set(placeholder: "LoginEmail".localised())
        field.setupLeftImage(named: "InputEmailIndicator")
        return field
    }()
    
    lazy var passwordField = {
        let field = TextFieldWithError()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.set(placeholder: "LoginPassword".localised())
        field.setupLeftImage(named: "InputSecureIndicator")
        field.set(secureInput: true)
        return field
    }()
    
    private var model: LoginFieldsCellModel?
    
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
        
        contentView.addSubview(loginField)
        loginField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.loginTopOffset).isActive = true
        loginField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.fieldsPadding).isActive = true
        loginField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.fieldsPadding).isActive = true
        
        contentView.addSubview(passwordField)
        passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: Constants.fieldsVerticalPadding).isActive = true
        passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.fieldsPadding).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.fieldsPadding).isActive = true
        passwordField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func set(model: LoginFieldsCellModel) {
        self.model = model
        loginField.set(state: model.loginFieldState)
        passwordField.set(state: model.passwordFieldState)
    }
    
    func setFieldsDelegate(_ delegate: UITextFieldDelegate) {
        loginField.set(delegate: delegate)
        passwordField.set(delegate: delegate)
    }
    
    func hideKeyboard() {
        loginField.hideKeyboard()
        passwordField.hideKeyboard()
    }
    
    func setState(_ state: TextFieldWithError.State, for field: UITextField) {
        if loginField.equal(to: field) {
            loginField.set(state: state)
            model?.loginFieldState = state
            return
        }
        
        if passwordField.equal(to: field) {
            passwordField.set(state: state)
            model?.passwordFieldState = state
            return
        }
    }
}
