//
//  RegisterMainVCViewModel.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/25/24.
//

import Foundation
import UIKit
import YOUUIComponents
import YOUProfileInterfaces
import YOUNetworking
import YOUUtils

final class RegisterMainVCViewModel: NSObject, LoginTableVCViewModel {
    private enum Constants {
        static let registerTitleCellID = "SignInTitleCell"
        static let fieldsCellID = "SignInFieldsCell"
        static let buttonFieldCellID = "SignInButtonsCell"
        static let separatorCellID = "LoginSeparatorCell"
        static let socialNetworkButtonsCellID = "LoginSocialNetworksCell"
        static let loginRegisterCellID = "SignInLoginCell"
        static let fieldsCellIndex: Int = 1
    }
    
    private weak var fieldsCell: SignInFieldsCell?
    private var fieldsCellModel = RegisterFieldsCellModel()
    private lazy var loaderManager: LoaderManager = {
        return LoaderManager()
    }()
    
    private var tableView: UITableView?
    private var viewController: UIViewController?
    
    private var tableInputScroller: TableViewInputScrollerService?
    
    var numberOfRows: Int {
        return 6
    }
    
    func cellForRow(with index: IndexPath, for table: UITableView) -> UITableViewCell {
        switch index.row {
        case Constants.fieldsCellIndex:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.fieldsCellID, for: index) as! SignInFieldsCell
            cell.set(model: fieldsCellModel)
            cell.setFieldsDelegate(self)
            fieldsCell = cell
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.buttonFieldCellID, for: index) as! SignInButtonsCell
            cell.setup { [weak self] in
                self?.hideKeyboards()
                guard self?.validateInput() == true else { return }
                
                if let vc = self?.viewController {
                    self?.loaderManager.addFullscreenLoader(for: vc)
                }
                
                AuthorizationAPIService.shared.requestRegister(email: self?.fieldsCellModel.loginString ?? "",
                                                            password: self?.fieldsCellModel.passwordString ?? "") { [weak self] success, errors, profile, token, rToken in
                    
                    if !errors.isEmpty {
                        self?.loaderManager.removeFullscreenLoader(completion: { [weak self] _ in
                            if let vc = self?.viewController {
                                AlertsPresenter.presentSomethingWentWrongAlert(from: vc, with: "Authorization.Error.EmailMayBeInUse".localised())
                            }
                        })
                        return
                    }
                    
                    defer {
                        self?.loaderManager.removeFullscreenLoader()
                    }
                    
                    guard success,
                            let profile = profile,
                            let token = token,
                            let rToken = rToken else { return }
                    ProfileManager.shared.set(profile: profile)
                    AuthorizationService.shared.token = token
                    AuthorizationService.shared.refreshToken = rToken
                    YOUNetworkingServices.secretNetworkService.refreshToken = rToken
                    YOUNetworkingServices.secretNetworkService.authToken = token
                    AuthorizationRouter.shared.endFlow()
                }
            }

            return cell
        case 3:
            return table.dequeueReusableCell(withIdentifier: Constants.separatorCellID, for: index)
        case 4:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.socialNetworkButtonsCellID, for: index) as! LoginSocialNetworksCell
            cell.setup(with: LoginSocialNetworksProvider.supportedNetworks()) { [weak self] network in
                print("Register -> authorize with: \(network.rawValue)")
                self?.hideKeyboards()
            }
            return cell
        case 5:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.loginRegisterCellID) as! SignInLoginCell
            cell.setup { [weak self] in
                AuthorizationRouter.shared.moveToLoginMain()
                self?.hideKeyboards()
            }
            return cell
        default:
            return table.dequeueReusableCell(withIdentifier: Constants.registerTitleCellID, for: index)
        }
    }
    
    private func validateInput() -> Bool {
        var validationErrors: [StringValidatorResult] = []
        let email = fieldsCellModel.loginString
        let emailValidationResult = EmailValidator().validate(value: email)
        if emailValidationResult != .success {
            validationErrors.append(emailValidationResult)
        }
        
        let passwordValidator = PasswordValidator()
        let password = fieldsCellModel.passwordString
        let passwordValidationResult = passwordValidator.validate(value: password)
        if passwordValidationResult != .success {
            validationErrors.append(passwordValidationResult)
        }
        
        let repeatPassword = fieldsCellModel.repeatPasswordString
        let repeatPasswordValidationResult = passwordValidator.isSame(password1: password, password2: repeatPassword)
        if repeatPasswordValidationResult != .success {
            validationErrors.append(repeatPasswordValidationResult)
        }
        
        handle(errors: validationErrors)
        
        return validationErrors.isEmpty
    }
    
    private func handle(errors: [StringValidatorResult]) {
        if let cell = fieldsCell {
            tableView?.beginUpdates()
            errors.reversed().forEach { error in
                switch error {
                case .invalidEmail:
                    cell.setState(.error(error: TextFieldWithError.FieldError(description: "AuthorizationError.InvalidEmail".localised())), for: cell.loginField)
                case .wrongPasswordLength:
                    cell.setState(.error(error: TextFieldWithError.FieldError(description: "AuthorizationError.ShortPassword".localised())), for: cell.passwordField)
                case .passwordsDoNotMatch:
                    cell.setState(.error(error: TextFieldWithError.FieldError(description: "AuthorizationError.PasswordsDoNotMatch".localised())), for: cell.repeatPasswordField)
                case .success:
                    break
                }
            }
            tableView?.endUpdates()
        }
    }
    
    func registerCells(for tableView: UITableView) {
        tableView.register(SignInTitleCell.self, forCellReuseIdentifier: Constants.registerTitleCellID)
        tableView.register(SignInFieldsCell.self, forCellReuseIdentifier: Constants.fieldsCellID)
        tableView.register(SignInButtonsCell.self, forCellReuseIdentifier: Constants.buttonFieldCellID)
        tableView.register(LoginSeparatorCell.self, forCellReuseIdentifier: Constants.separatorCellID)
        tableView.register(LoginSocialNetworksCell.self, forCellReuseIdentifier: Constants.socialNetworkButtonsCellID)
        tableView.register(SignInLoginCell.self, forCellReuseIdentifier: Constants.loginRegisterCellID)
    }
    
    func didScrollByUser() {
        hideKeyboards()
    }
    
    func set(tableView: UITableView, 
             viewController: UIViewController,
             bottomConstraint: NSLayoutConstraint) {
        self.tableView = tableView
        self.viewController = viewController
        self.tableInputScroller = TableViewInputScrollerService(mainView: viewController.view,
                                                                tableView: tableView, bottomConstraint: bottomConstraint,
                                                                delegate: self)
    }
    
    private func hideKeyboards() {
        fieldsCell?.hideKeyboard()
    }
}

extension RegisterMainVCViewModel: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            fieldsCell?.setRightView(visible: !updatedText.isEmpty, for: textField)
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        fieldsCell?.setRightView(visible: false, for: textField)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView?.beginUpdates()
        fieldsCell?.setState(.typing, for: textField)
        tableView?.endUpdates()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let input = textField.text ?? ""
        let isEmpty = input.isEmpty
        tableView?.beginUpdates()
        fieldsCell?.setState(isEmpty ? .default : .typed, for: textField)
        fieldsCell?.saveValue(for: textField)
        tableView?.endUpdates()
    }
}

extension RegisterMainVCViewModel: TableViewInputScrollerDelegate {
    func indexPath(for type: TableViewInputScrollerType) -> IndexPath? {
        guard let cell = fieldsCell else { return nil }
        return tableView?.indexPath(for: cell)
    }
}
