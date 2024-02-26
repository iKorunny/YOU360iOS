//
//  LoginMainVCViewModel.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/23/24.
//

import Foundation
import UIKit
import YOUUIComponents

final class LoginMainVCViewModel: NSObject, LoginTableVCViewModel {
    private enum Constants {
        static let loginTitleCellID = "LoginTitleCell"
        static let fieldsCellID = "LoginFieldsCell"
        static let buttonsFieldCellID = "LoginButtonsCell"
        static let separatorCellID = "LoginSeparatorCell"
        static let socialNetworkButtonsCellID = "LoginSocialNetworksCell"
        static let loginRegisterCellID = "LoginRegisterCell"
        static let fieldsCellIndex: Int = 1
    }
    
    private weak var fieldsCell: LoginFieldsCell?
    private var fieldsCellModel = LoginFieldsCellModel()
    
    var tableView: UITableView?
    
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
            cell.setup {
                print("Login -> Log in")
                AuthorizationAPIService.shared.requestLogin(email: "user@example.com", password: "string") { success, error, data, string in
                    print()
                }
            } forgotPasswordAction: {
                print("Login -> Forgot Password")
            }

            return cell
        case 3:
            return table.dequeueReusableCell(withIdentifier: Constants.separatorCellID, for: index)
        case 4:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.socialNetworkButtonsCellID, for: index) as! LoginSocialNetworksCell
            cell.setup(with: LoginSocialNetworksProvider.supportedNetworks()) { network in
                print("Login -> authorize with: \(network.rawValue)")
            }
            return cell
        case 5:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.loginRegisterCellID) as! LoginRegisterCell
            cell.setup {
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
    
    func didScroll() {
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
    }
}
