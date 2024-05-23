//
//  ProfileScreenFactory.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/1/24.
//

import Foundation
import UIKit
import YOUUIComponents
import YOUAuthorization

public final class ProfileScreenFactory {
    public static func createMyProfileRootVC() -> UINavigationController {
        return YOUNavigationController(rootViewController: MyProfileVC(viewModel: MyProfileVCViewModelImpl(profileManager: ProfileManager.shared)), type: .you)
    }
    public static func createProfileEditVC(onClose: @escaping ((Bool, Bool, UIImage?, UIImage?, Bool) -> Void)) -> UIViewController {
        return ProfileEditVC(viewModel: ProfileEditScreenViewModelImpl(profileManager: ProfileManager.shared, onClose: onClose))
    }
    
    public static func createReserveRootVC() -> UINavigationController {
        return YOUNavigationController(rootViewController: UIViewController(), type: .reserve)
    }
    
    public static func createMenuVC(onClose: @escaping (() -> Void)) -> UIViewController {
        return MenuVC(viewModel: MenuViewModelImpl(onClose: onClose))
    }
}
