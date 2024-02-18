//
//  MainRouter.swift
//  YOU360
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import UIKit
import YOUAuthorization

final class MainRouter {
    static var shared = {
       return MainRouter()
    }()
    
    private(set) var mainWindow: UIWindow?
    
    func set(mainWindow: UIWindow?) {
        guard let window = mainWindow else { return }
        self.mainWindow? = window
    }
    
    func routeToLogin() {
        AuthorizationRouter.shared.startLoginFlow()
    }
    
    func routeToApp() {
        mainWindow?.makeKeyAndVisible()
    }
}
