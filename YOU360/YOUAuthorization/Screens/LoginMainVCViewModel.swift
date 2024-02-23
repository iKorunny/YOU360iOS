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
    }
    
    var numberOfRows: Int {
        return 6
    }
    
    func cellForRow(with index: IndexPath, for table: UITableView) -> UITableViewCell {
        switch index.row {
        case 1:
            return table.dequeueReusableCell(withIdentifier: Constants.fieldsCellID, for: index)
        default:
            return table.dequeueReusableCell(withIdentifier: Constants.loginTitleCellID, for: index)
        }
    }
    
    func registerCells(for tableView: UITableView) {
        tableView.register(LoginTitleCell.self, forCellReuseIdentifier: Constants.loginTitleCellID)
        tableView.register(LoginFieldsCell.self, forCellReuseIdentifier: Constants.fieldsCellID)
    }
}
