//
//  AuthorizationRouter.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import UIKit

public final class AuthorizationRouter {
    public static var shared = {
        AuthorizationRouter()
    }()
    
    private var rootVC: UINavigationController?
    
    private lazy var loginWindow: UIWindow? = {
        let windowScene = UIApplication.shared
                        .connectedScenes
                        .first
        guard let windowScene = windowScene as? UIWindowScene else { return nil }
        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = .alert
        window.frame = windowScene.screen.bounds
        return window
    }()
    
    public func startLoginFlow() {
        let startScreen = LoginScreensFactory.makeStartLogin()
        rootVC = startScreen
        loginWindow?.rootViewController = startScreen
        loginWindow?.makeKeyAndVisible()
    }
    
    func moveToLoginMain() {
        rootVC?.pushViewController(LoginScreensFactory.createLoginMainScreen(), animated: true)
    }
}
