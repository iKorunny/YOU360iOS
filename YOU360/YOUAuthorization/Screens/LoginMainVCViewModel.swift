//
//  LoginMainVCViewModel.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/23/24.
//

import Foundation
import UIKit
import YOUUIComponents
import YOUProfileInterfaces
import YOUNetworking
import YOUUtils

final class LoginMainVCViewModel: NSObject, LoginTableVCViewModel {
    private enum Constants {
        static let loginTitleCellID = "LoginTitleCell"
        static let fieldsCellID = "LoginFieldsCell"
        static let buttonsFieldCellID = "LoginButtonsCell"
        static let separatorCellID = "LoginSeparatorCell"
        static let socialNetworkButtonsCellID = "LoginSocialNetworksCell"
        static let loginRegisterCellID = "LoginRegisterCell"
        static let fieldsCellIndex: Int = 1
        
        static let debugLogin = "user@example.com"
        static let debugPassword = "string"
    }
    
    private weak var fieldsCell: LoginFieldsCell?
    private var fieldsCellModel = LoginFieldsCellModel()
    private lazy var loaderManager: LoaderManager = {
        return LoaderManager()
    }()
    
    private var tableView: UITableView?
    private var viewController: UIViewController?
    
    private var tableInputScroller: TableViewInputScrollerService?
    private var tableUpdater: TableUpdater?
    
    var numberOfRows: Int {
        return 6
    }
    
    func cellForRow(with index: IndexPath, for table: UITableView) -> UITableViewCell {
        switch index.row {
        case Constants.fieldsCellIndex:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.fieldsCellID, for: index) as! LoginFieldsCell
            cell.set(model: fieldsCellModel)
            cell.setFieldsDelegate(self)
            fieldsCell = cell
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.buttonsFieldCellID, for: index) as! LoginButtonsCell
            cell.setup { [ weak self] in
                self?.hideKeyboards()
                guard self?.validateInput() == true else { return }
                if let vc = self?.viewController {
                    self?.loaderManager.addFullscreenLoader(for: vc)
                }
                
                AuthorizationAPIService.shared.requestLogin(email: self?.fieldsCellModel.loginString ?? "",
                                                            password: self?.fieldsCellModel.passwordString ?? "") { [weak self] success, errors, profile, token, rToken in
                    if !errors.isEmpty {
                        self?.loaderManager.removeFullscreenLoader(completion: { [weak self] _ in
                            if let vc = self?.viewController {
                                AlertsPresenter.presentSomethingWentWrongAlert(from: vc, with: "Authorization.Error.CheckInput".localised())
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
            } forgotPasswordAction: { [weak self] in
                print("Login -> Forgot Password")
                self?.hideKeyboards()
            }

            return cell
        case 3:
            return table.dequeueReusableCell(withIdentifier: Constants.separatorCellID, for: index)
        case 4:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.socialNetworkButtonsCellID, for: index) as! LoginSocialNetworksCell
            cell.setup(with: LoginSocialNetworksProvider.supportedNetworks()) { [weak self] network in
                print("Login -> authorize with: \(network.rawValue)")
                self?.hideKeyboards()
            }
            return cell
        case 5:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.loginRegisterCellID) as! LoginRegisterCell
            cell.setup { [weak self] in
                self?.hideKeyboards()
                AuthorizationRouter.shared.moveToRegister()
            }
            return cell
        default:
            return table.dequeueReusableCell(withIdentifier: Constants.loginTitleCellID, for: index)
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
        
        handle(errors: validationErrors)
        
        return validationErrors.isEmpty
    }
    
    private func handle(errors: [StringValidatorResult]) {
        if let cell = fieldsCell {
            tableUpdater?.update {
                errors.reversed().forEach { error in
                    switch error {
                    case .invalidEmail:
                        cell.setState(.error(error: TextFieldWithError.FieldError(description: "AuthorizationError.InvalidEmail".localised())), for: cell.loginField)
                    case .wrongPasswordLength:
                        cell.setState(.error(error: TextFieldWithError.FieldError(description: "AuthorizationError.ShortPassword".localised())), for: cell.passwordField)
                    case .success, .passwordsDoNotMatch:
                        break
                    }
                }
            }
        }
    }
    
    func registerCells(for tableView: UITableView) {
        tableView.register(LoginTitleCell.self, forCellReuseIdentifier: Constants.loginTitleCellID)
        tableView.register(LoginFieldsCell.self, forCellReuseIdentifier: Constants.fieldsCellID)
        tableView.register(LoginButtonsCell.self, forCellReuseIdentifier: Constants.buttonsFieldCellID)
        tableView.register(LoginSeparatorCell.self, forCellReuseIdentifier: Constants.separatorCellID)
        tableView.register(LoginSocialNetworksCell.self, forCellReuseIdentifier: Constants.socialNetworkButtonsCellID)
        tableView.register(LoginRegisterCell.self, forCellReuseIdentifier: Constants.loginRegisterCellID)
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
        self.tableUpdater = TableUpdater(table: tableView)
    }
    
    private func hideKeyboards() {
        fieldsCell?.hideKeyboard()
    }
}

extension LoginMainVCViewModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableUpdater?.update { [weak self] in
            self?.fieldsCell?.setState(.typing, for: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let input = textField.text ?? ""
        let isEmpty = input.isEmpty
        tableUpdater?.update { [weak self] in
            self?.fieldsCell?.setState(isEmpty ? .default : .typed, for: textField)
            self?.fieldsCell?.saveValue(for: textField)
        }
    }
}

extension LoginMainVCViewModel: TableViewInputScrollerDelegate {
    func indexPath(for type: TableViewInputScrollerType) -> IndexPath? {
        guard let cell = fieldsCell else { return nil }
        return tableView?.indexPath(for: cell)
    }
}
