//
//  SignInFieldsCell.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/25/24.
//

import UIKit
import YOUUIComponents
import YOUUtils

final class RegisterFieldsCellModel {
    var loginFieldState: TextFieldWithError.State = .default
    var passwordFieldState: TextFieldWithError.State = .default
    var repeatPasswordFieldState: TextFieldWithError.State = .default
    
    var passwordSecure: Bool = true
    var repeatPasswordSecure: Bool = true
}

final class SignInFieldsCell: UITableViewCell {
    
    deinit {
        model?.passwordSecure = passwordField.isSecure
        model?.repeatPasswordSecure = repeatPasswordField.isSecure
    }

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
        field.set(secureInput: model?.passwordSecure ?? true, showControl: false)
        return field
    }()
    
    lazy var repeatPasswordField = {
        let field = TextFieldWithError()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.set(placeholder: "RegisterRepeatPassword".localised())
        field.setupLeftImage(named: "InputSecureIndicator")
        field.set(secureInput: model?.repeatPasswordSecure ?? true, showControl: false)
        return field
    }()
    
    private var model: RegisterFieldsCellModel?
    
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
        
        contentView.addSubview(repeatPasswordField)
        repeatPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: Constants.fieldsVerticalPadding).isActive = true
        repeatPasswordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.fieldsPadding).isActive = true
        repeatPasswordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.fieldsPadding).isActive = true
        repeatPasswordField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func set(model: RegisterFieldsCellModel) {
        self.model = model
        loginField.set(state: model.loginFieldState)
        passwordField.set(state: model.passwordFieldState)
        repeatPasswordField.set(state: model.repeatPasswordFieldState)
        
        passwordField.set(secureInput: model.passwordSecure, showControl: !passwordField.isEmpty)
        repeatPasswordField.set(secureInput: model.repeatPasswordSecure, showControl: !repeatPasswordField.isEmpty)
    }
    
    func setFieldsDelegate(_ delegate: UITextFieldDelegate) {
        loginField.set(delegate: delegate)
        passwordField.set(delegate: delegate)
        repeatPasswordField.set(delegate: delegate)
    }
    
    func hideKeyboard() {
        loginField.hideKeyboard()
        passwordField.hideKeyboard()
        repeatPasswordField.hideKeyboard()
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
        
        if repeatPasswordField.equal(to: field) {
            repeatPasswordField.set(state: state)
            model?.repeatPasswordFieldState = state
            return
        }
    }

    func setRightView(visible: Bool, for field: UITextField) {
        if passwordField.equal(to: field) {
            passwordField.setRightView(visible: visible)
            return
        }
        
        if repeatPasswordField.equal(to: field) {
            repeatPasswordField.setRightView(visible: visible)
            return
        }
    }
}
