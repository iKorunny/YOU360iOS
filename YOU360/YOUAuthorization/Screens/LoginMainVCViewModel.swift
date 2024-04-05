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
    
    var tableView: UITableView?
    var viewController: UIViewController?
    
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
                print("Login -> Log in")
                self?.hideKeyboards()
                if let vc = self?.viewController {
                    self?.loaderManager.addFullscreenLoader(for: vc)
                }
                
                AuthorizationAPIService.shared.requestLogin(email: self?.fieldsCellModel.loginString ?? "",
                                                            password: self?.fieldsCellModel.passwordString ?? "") { [weak self] success, errors, profile, token, rToken in
                    defer {
                        self?.loaderManager.removeFullscreenLoader()
                    }
                    
                    if !errors.isEmpty {
                        // TODO: will handle errors here
                        return
                    }
                    
                    guard success, 
                            let profile = profile,
                            let token = token, 
                            let rToken = rToken else { return }
                    ProfileManager.shared.profile = profile
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
    
    private func hideKeyboards() {
        fieldsCell?.hideKeyboard()
    }
    
    private func show(error: TextFieldWithError.FieldError, for field: UITextField) {
        fieldsCell?.setState(.error(error: error), for: field)
        tableView?.reloadRows(at: [IndexPath(row: Constants.fieldsCellIndex, section: 0)], with: .none)
    }
}

extension LoginMainVCViewModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fieldsCell?.setState(.typing, for: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let input = textField.text ?? ""
        let isEmpty = input.isEmpty
        fieldsCell?.setState(isEmpty ? .default : .typed, for: textField)
        fieldsCell?.saveValue(for: textField)
    }
}
