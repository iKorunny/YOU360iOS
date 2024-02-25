//
//  LoginTableVCViewModel.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/25/24.
//

import Foundation
import UIKit

protocol LoginTableVCViewModel {
    var tableView: UITableView? { get set }
    var numberOfRows: Int { get }
    func cellForRow(with index: IndexPath, for table: UITableView) -> UITableViewCell
    func registerCells(for tableView: UITableView)
    func didScroll()
}
