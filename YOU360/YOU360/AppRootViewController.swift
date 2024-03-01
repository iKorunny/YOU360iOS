//
//  AppRootViewController.swift
//  YOU360
//
//  Created by Ihar Karunny on 2/18/24.
//

import UIKit
import YOUAuthorization
import YOUUtils
import YOUProfile

class AppRootViewController: UIViewController {
    
    private enum State: Int {
        case nonAuthorized
        case authorized
    }
    
    deinit {
        guard let loginObserver = loginObserver else { return }
        AuthorizationService.shared.removeLogin(observer: loginObserver)
    }
    
    private var loginObserver: AnyObject?
    private var state: State = .nonAuthorized {
        didSet {
            updateUIWith(state: state)
        }
    }
    
    private lazy var nonAuthorizedView: UIView = {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = ColorPallete.appWhiteSecondary
        newView.isHidden = true
        let logoView = UIImageView(image: UIImage(named: "LOGOYOU360"))
        logoView.translatesAutoresizingMaskIntoConstraints = false
        newView.addSubview(logoView)
        logoView.centerYAnchor.constraint(equalTo: newView.centerYAnchor).isActive = true
        logoView.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
        return newView
    }()
    
    private lazy var tabBarVC: UITabBarController = {
        let tabBar = UITabBarController()
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        tabBar.tabBar.barTintColor = ColorPallete.appWhite.withAlphaComponent(0.8)
        tabBar.tabBar.isTranslucent = false
        tabBar.viewControllers = [ProfileScreenFactory.createRootVC()]
        return tabBar
    }()
    
    private lazy var authorizedView: UIView = {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = ColorPallete.appWhiteSecondary
        newView.isHidden = true
        return newView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        SafeStorage.removeToken()
        
        setupUI()
        state = AuthorizationService.shared.isAuthorized ? .authorized : .nonAuthorized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !AuthorizationService.shared.isAuthorized {
            loginObserver = AuthorizationService.shared.observeLoginStatus { [weak self] in
                self?.state = AuthorizationService.shared.isAuthorized ? .authorized : .nonAuthorized
            }
            DispatchQueue.main.async {
                MainRouter.shared.routeToLogin()
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(nonAuthorizedView)
        nonAuthorizedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nonAuthorizedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        nonAuthorizedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nonAuthorizedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(authorizedView)
        authorizedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        authorizedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        authorizedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        authorizedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tabBarVC.willMove(toParent: self)
        authorizedView.addSubview(tabBarVC.view)
        addChild(tabBarVC)
        tabBarVC.didMove(toParent: self)
        
        tabBarVC.view.topAnchor.constraint(equalTo: authorizedView.topAnchor).isActive = true
        tabBarVC.view.bottomAnchor.constraint(equalTo: authorizedView.bottomAnchor).isActive = true
        tabBarVC.view.leadingAnchor.constraint(equalTo: authorizedView.leadingAnchor).isActive = true
        tabBarVC.view.trailingAnchor.constraint(equalTo: authorizedView.trailingAnchor).isActive = true
    }
    
    private func updateUIWith(state: State) {
        switch state {
        case .nonAuthorized:
            nonAuthorizedView.isHidden = false
            authorizedView.isHidden = true
        case .authorized:
            nonAuthorizedView.isHidden = true
            authorizedView.isHidden = false
        }
    }
}

