//
//  LoginMainVC.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/20/24.
//

import UIKit
import YOUUIComponents
import YOUUtils

final class LoginMainVC: CustomNavigationViewController {
    
    private enum Constants {
        static let tableTopOffset: CGFloat = 88
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        viewModel.registerCells(for: table)
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    private let viewModel: LoginMainVCViewModel
    
    init(viewModel: LoginMainVCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = nil
        view.backgroundColor = ColorPallete.appWhiteSecondary
        navigationController?.navigationBar.tintColor = ColorPallete.appWhiteSecondary
        navigationController?.navigationBar.barTintColor = ColorPallete.appWhiteSecondary
        
        setupUI()
    }
    
    private func setupUI() {
//        let field = TextFieldWithError()
//        field.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(field)
//        field.widthAnchor.constraint(equalToConstant: 355).isActive = true
//        field.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.tableTopOffset).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension LoginMainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(with: indexPath, for: tableView)
    }
}
