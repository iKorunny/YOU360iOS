//
//  AuthorizationRouter.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import UIKit

public final class AuthorizationRouter: NSObject {
    public static var shared = {
        AuthorizationRouter()
    }()
    
    private var rootVC: UINavigationController? {
        didSet {
            rootVC?.delegate = self
        }
    }
    
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
        let startScreen = LoginScreensFactory.makeRootLogin()
        rootVC = startScreen
        loginWindow?.rootViewController = startScreen
        loginWindow?.makeKeyAndVisible()
    }
    
    func moveToLoginMain() {
        rootVC?.pushViewController(LoginScreensFactory.createLoginMainScreen(), animated: true)
    }
    
    func moveToRegister() {
        
    }
}

extension AuthorizationRouter: UINavigationControllerDelegate {
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
}
