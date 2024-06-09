//
//  MenuVC.swift
//  YOUProfile
//
//  Created by Andrey Matoshko on 10.04.24.
//

import UIKit
import YOUUIComponents
import YOUUtils

protocol MenuView {
    func reload()
}

final class MenuVC: UIViewController, MenuView {
    
    private enum Constants {
        static let backButtonInsets = UIEdgeInsets(top: 52, left: 20, bottom: 0, right: 0)
        static let backgroundColor = ColorPallete.appDarkWhite
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NavigationBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(logoutBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var holdView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorPallete.appBlackSecondary
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 5),
            view.widthAnchor.constraint(equalToConstant: 87),
        ])

        return view
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
    
    private var viewModel: MenuViewModel
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        viewModel.onViewDidLoad()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        holdView.layer.cornerRadius = holdView.bounds.height / 2
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    private func setupUI() {
        setupTableView()
        
        view.addSubview(holdView)
        NSLayoutConstraint.activate([
            holdView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            holdView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        view.backgroundColor = Constants.backgroundColor
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        tableView.backgroundColor = .clear
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setupButtons() {
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.backButtonInsets.left).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.backButtonInsets.top).isActive = true
    }

    @objc private func logoutBack() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }

}
