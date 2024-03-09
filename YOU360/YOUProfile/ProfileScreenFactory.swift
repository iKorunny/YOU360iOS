//
//  ProfileScreenFactory.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/1/24.
//

import Foundation
import UIKit
import YOUUIComponents
import YOUProfileInterfaces

public final class ProfileScreenFactory {
    public static func createMyProfileRootVC() -> UINavigationController {
        return YOUNavigationController(rootViewController: ProfileVC(viewModel: MyProfileVCViewModelImpl(profileManager: ProfileManager.shared)), type: .you)
    }
    public static func createProfileEditVC() -> UIViewController {
        return ProfileEditVC()
    }
    
    public static func createReserveRootVC() -> UINavigationController {
        return YOUNavigationController(rootViewController: UIViewController(), type: .reserve)
    }
}
