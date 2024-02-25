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
    
    private weak var loginMainVCRef: AnyObject?
    private weak var registerMainVCRef: AnyObject?
    
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
        if let rootVC = rootVC {
            let screensStack = rootVC.viewControllers
            let screensStackCount = screensStack.count
            
            if screensStackCount > 2 && screensStack[screensStackCount - 2] === loginMainVCRef {
                rootVC.popViewController(animated: true)
                return
            }
        }
        
        let loginMain = LoginScreensFactory.createLoginMainScreen()
        loginMainVCRef = loginMain
        rootVC?.pushViewController(loginMain, animated: true)
    }
    
    func moveToRegister() {
        if let rootVC = rootVC {
            let screensStack = rootVC.viewControllers
            let screensStackCount = screensStack.count
            
            if screensStackCount > 2 && screensStack[screensStackCount - 2] === registerMainVCRef {
                rootVC.popViewController(animated: true)
                return
            }
        }
        
        let registerMain = LoginScreensFactory.createRegisterMainScreen()
        registerMainVCRef = registerMain
        rootVC?.pushViewController(registerMain, animated: true)
    }
}

extension AuthorizationRouter: UINavigationControllerDelegate {
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
}
