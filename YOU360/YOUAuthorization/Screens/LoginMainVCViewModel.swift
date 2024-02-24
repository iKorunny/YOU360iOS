//
//  LoginMainVCViewModel.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/23/24.
//

import Foundation
import UIKit
import YOUUIComponents

protocol LoginMainVCViewModel {
    var numberOfRows: Int { get }
    func cellForRow(with index: IndexPath, for table: UITableView) -> UITableViewCell
    func registerCells(for tableView: UITableView)
}

final class LoginMainVCViewModelImpl: LoginMainVCViewModel {
    private enum Constants {
        static let loginTitleCellID = "LoginTitleCell"
        static let fieldsCellID = "LoginFieldsCell"
        static let buttonsFieldCellID = "LoginButtonsCell"
        static let separatorCellID = "LoginSeparatorCell"
        static let socialNetworkButtonsCellID = "LoginSocialNetworksCell"
        static let loginRegisterCellID = "LoginRegisterCell"
    }
    
    var numberOfRows: Int {
        return 6
    }
    
    func cellForRow(with index: IndexPath, for table: UITableView) -> UITableViewCell {
        switch index.row {
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.fieldsCellID, for: index) as! LoginFieldsCell
            return cell
        case 2:
            let cell = table.dequeueReusableCell(withIdentifier: Constants.buttonsFieldCellID, for: index) as! LoginButtonsCell
            cell.setup {
                print("Login -> Log in")
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
                print("Login -> to register")
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
}
