//
//  LoginTableVC.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/20/24.
//

import UIKit
import YOUUIComponents
import YOUUtils

final class LoginTableVC: CustomNavigationViewController {
    
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
    
    private var viewModel: LoginTableVCViewModel
    
    init(viewModel: LoginTableVCViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tableView = tableView
        viewModel.viewController = self

        title = nil
        view.backgroundColor = ColorPallete.appWhiteSecondary
        navigationController?.navigationBar.tintColor = ColorPallete.appWhiteSecondary
        navigationController?.navigationBar.barTintColor = ColorPallete.appWhiteSecondary
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.tableTopOffset).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension LoginTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(with: indexPath, for: tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.didScroll()
    }
}
