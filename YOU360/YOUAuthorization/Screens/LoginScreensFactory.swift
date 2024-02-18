//
//  LoginScreensFactory.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import UIKit

final class LoginScreensFactory {
    static func makeStartLogin() -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: LoginStartVC())
        return navigationVC
    }
}
