//
//  AppRootViewController.swift
//  YOU360
//
//  Created by Ihar Karunny on 2/18/24.
//

import UIKit
import YOUAuthorization
import YOUUtils

class AppRootViewController: UIViewController {
    
    deinit {
        guard let loginObserver = loginObserver else { return }
        AuthorizationService.shared.removeLogin(observer: loginObserver)
    }
    
    private var loginObserver: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        SafeStorage.removeToken()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !AuthorizationService.shared.isAuthorized {
            loginObserver = AuthorizationService.shared.observeLogin { success in
                guard success else { return }
                MainRouter.shared.routeToApp()
            }
            DispatchQueue.main.async {
                MainRouter.shared.routeToLogin()
            }
        }
    }
}

