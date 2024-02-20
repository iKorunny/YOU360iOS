//
//  CustomNavigationViewController.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/20/24.
//

import UIKit
import YOUUtils

open class CustomNavigationViewController: UIViewController {
    private enum Constants {
        static let barHeight: CGFloat = 44
        static let barTopOffset: CGFloat = 52
    }
    
    public lazy var customNavigationBar: CustomNavigationBar = {
        let bar = CustomNavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .clear
        return bar
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = ColorPallete.appWhite
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(customNavigationBar)
        customNavigationBar.heightAnchor.constraint(equalToConstant: Constants.barHeight).isActive = true
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.barTopOffset).isActive = true
        customNavigationBar.setBackButton(target: self, action: #selector(popBack), for: .touchUpInside)
        
        customNavigationBar.setBackButton(hidden: true)
        guard let navigationController = navigationController else { return }
        customNavigationBar.setBackButton(hidden: navigationController.viewControllers.first === self)
    }
    
    @objc private func popBack() {
        navigationController?.popViewController(animated: true)
    }
}
