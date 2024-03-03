//
//  MainRouter.swift
//  YOU360
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import UIKit
import YOUAuthorization
import YOUProfileInterfaces

protocol MainVC {
    func toMyProfile()
    func toHomeVC()
}

final class MainRouter {
    static var shared = {
       return MainRouter()
    }()
    
    private(set) var mainWindow: UIWindow?
    
    var mainVC: MainVC? {
        didSet {
            navigateToStartScreen()
        }
    }
    
    func set(mainWindow: UIWindow?) {
        guard let window = mainWindow else { return }
        self.mainWindow? = window
        navigateToStartScreen()
    }
    
    func routeToLogin() {
        AuthorizationRouter.shared.startLoginFlow { [weak self] in
            self?.routeToApp()
            self?.navigateToStartScreen()
        }
    }
    
    func routeToApp() {
        mainWindow?.makeKeyAndVisible()
    }
    
    private func navigateToStartScreen() {
        if ProfileManager.shared.isProfileEdited {
            mainVC?.toHomeVC()
        }
        else {
            mainVC?.toMyProfile()
        }
    }
}
