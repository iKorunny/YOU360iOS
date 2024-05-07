//
//  ProfileEditVC.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/9/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class ProfileEditVC: UIViewController {
    
    private enum Constants {
        static let backButtonInsets = UIEdgeInsets(top: 52, left: 20, bottom: 0, right: 0)
        static let saveButtonInsets = UIEdgeInsets(top: 52, left: 0, bottom: 0, right: 20)
        static let saveButtonFontSize: CGFloat = 18
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NavigationBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = ButtonsFactory.createTextButton(
            title: "ProfileEditVCSaveButton".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.saveButtonFontSize),
            titleColor: ColorPallete.appPink,
            highLightedTitleColor: ColorPallete.appDarkPink,
            target: self,
            action: #selector(onSave),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = ColorPallete.appWhiteSecondary
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private let viewModel: ProfileEditScreenViewModel
    
    init(viewModel: ProfileEditScreenViewModel) {
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
        
        viewModel.deactivateInputFields()
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.onWillDissapear()
        }
    }
    
    private func setupUI() {
        setupTableView()
        setupTopButtons()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewModel.set(tableView: tableView,
                      controller: self,
                      tableViewBottomConstraint: bottomConstraint)
    }
    
    private func setupTopButtons() {
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.backButtonInsets.left).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.backButtonInsets.top).isActive = true
        backButton.isHidden = ((navigationController?.viewControllers ?? []).count == 1 || navigationController?.visibleViewController !== self)
        
        view.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.saveButtonInsets.top).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.saveButtonInsets.right).isActive = true
    }
    
    @objc private func popBack() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func onSave() {
        viewModel.onSave()
    }
}

extension ProfileEditVC: ProfileEditScreenView {
    func close() {
        popBack()
    }
}
