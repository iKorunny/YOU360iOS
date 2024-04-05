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
    
    var tableView: UITableView?
    var viewController: UIViewController?
    
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
                print("Register -> sign in")
                self?.hideKeyboards()
                if let vc = self?.viewController {
                    self?.loaderManager.addFullscreenLoader(for: vc)
                }
                
                AuthorizationAPIService.shared.requestRegister(email: self?.fieldsCellModel.loginString ?? "",
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
                    ProfileManager.shared.isProfileEdited = profile.profileFilled
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
    
    private func hideKeyboards() {
        fieldsCell?.hideKeyboard()
    }
    
    private func show(error: TextFieldWithError.FieldError, for field: UITextField) {
        fieldsCell?.setState(.error(error: error), for: field)
        tableView?.reloadRows(at: [IndexPath(row: Constants.fieldsCellIndex, section: 0)], with: .none)
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
        fieldsCell?.setState(.typing, for: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let input = textField.text ?? ""
        let isEmpty = input.isEmpty
        fieldsCell?.setState(isEmpty ? .default : .typed, for: textField)
        fieldsCell?.saveValue(for: textField)
    }
}
