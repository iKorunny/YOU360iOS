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
import YOUEstablishments
import YOUChat
import YOUUIComponents

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
    
    private var tabBarSelectedIndex: Int = 0
    
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
    
    private var tabBarVC: UITabBarController?
    
    private lazy var authorizedView: UIView = {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = ColorPallete.appWhiteSecondary
        newView.isHidden = true
        return newView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        MainRouter.shared.mainVC = self

        setupUI()
        state = AuthorizationService.shared.isAuthorized ? .authorized : .nonAuthorized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginObserver = AuthorizationService.shared.observeLoginStatus { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.state = AuthorizationService.shared.isAuthorized ? .authorized : .nonAuthorized
                if !AuthorizationService.shared.isAuthorized {
                    MainRouter.shared.routeToLogin()
                }
            }
        }
        
        if !AuthorizationService.shared.isAuthorized {
            DispatchQueue.main.async {
                MainRouter.shared.routeToLogin()
            }
        }
    }
    
    private func createTabBarVC() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        tabBar.tabBar.barTintColor = ColorPallete.appWhite.withAlphaComponent(0.8)
        tabBar.tabBar.isTranslucent = true
        tabBar.tabBar.backgroundColor = ColorPallete.appWhite.withAlphaComponent(0.8)
        
        let reserveVC = ProfileScreenFactory.createReserveRootVC()
        let myProfileVC = ProfileScreenFactory.createMyProfileRootVC()
        ProfileRouter.shared.rootProfileVC = myProfileVC
        ProfileRouter.shared.rootReserveVC = reserveVC
        tabBar.viewControllers = [
            EstablishmentsScreenFactory.createHomeRootVC(),
            EstablishmentsScreenFactory.createTopRootVC(),
            ChatScreenFactory.createChatRootVC(),
            reserveVC,
            myProfileVC
        ]
        tabBar.selectedIndex = tabBarSelectedIndex
        tabBarSelectedIndex = 0
        return tabBar
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
    }
    
    private func setupAuthorizedPart() {
        let newTabBar = createTabBarVC()
        tabBarVC = newTabBar
        newTabBar.willMove(toParent: self)
        authorizedView.addSubview(newTabBar.view)
        addChild(newTabBar)
        newTabBar.didMove(toParent: self)
        
        newTabBar.view.topAnchor.constraint(equalTo: authorizedView.topAnchor).isActive = true
        newTabBar.view.bottomAnchor.constraint(equalTo: authorizedView.bottomAnchor).isActive = true
        newTabBar.view.leadingAnchor.constraint(equalTo: authorizedView.leadingAnchor).isActive = true
        newTabBar.view.trailingAnchor.constraint(equalTo: authorizedView.trailingAnchor).isActive = true
    }
    
    private func updateUIWith(state: State) {
        switch state {
        case .nonAuthorized:
            nonAuthorizedView.isHidden = false
            authorizedView.isHidden = true
            tabBarVC?.removeFromParent()
            tabBarVC?.view.removeFromSuperview()
            tabBarVC = nil
        case .authorized:
            nonAuthorizedView.isHidden = true
            authorizedView.isHidden = false
            setupAuthorizedPart()
        }
    }
}

extension AppRootViewController: MainVC {
    func toMyProfile() {
        toItem(type: .you)
    }
    
    func toHomeVC() {
        toItem(type: .home)
    }
    
    private func toItem(type: YOUNavigationControllerItemType) {
        if let tabBarVC {
            tabBarVC.selectedIndex = type.rawValue
        }
        else {
            tabBarSelectedIndex = type.rawValue
        }
    }
}
