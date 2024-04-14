//
//  MenuVC.swift
//  YOUProfile
//
//  Created by Andrey Matoshko on 10.04.24.
//

import UIKit
import YOUUIComponents
import YOUUtils

final class MenuVC: UIViewController {
    
    private enum Constants {
        static let backButtonInsets = UIEdgeInsets(top: 52, left: 20, bottom: 0, right: 0)
        static let backgroundColor = ColorPallete.appDarkWhite
    }
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NavigationBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(logoutBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = ColorPallete.appWhiteSecondary
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.translatesAutoresizingMaskIntoConstraints = false
        viewModel.set(tableView: table)
        
        return table
    }()
    
    private let viewModel: MenuViewModel
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = ColorPallete.appWhiteSecondary
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.onWillDissapear()
        }
    }
    
    private func setupUI() {
        setupTableView()
        setupButtons()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        view.backgroundColor = Constants.backgroundColor
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        tableView.backgroundColor = .clear
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setupButtons() {
        view.addSubview(logoutButton)
        logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.backButtonInsets.left).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.backButtonInsets.top).isActive = true
        logoutButton.isHidden = ((navigationController?.viewControllers ?? []).count == 1 || navigationController?.visibleViewController !== self)
    }

    @objc private func logoutBack() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }

}
