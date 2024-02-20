//
//  LoginScreensFactory.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import UIKit

final class LoginScreensFactory {
    static func makeStartLogin() -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: LoginStartVC())
        return navigationVC
    }
    
    static func createLoginMainScreen() -> UIViewController {
        return LoginMainVC()
    }
}
