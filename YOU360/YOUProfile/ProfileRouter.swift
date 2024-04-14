//
//  ProfileRouter.swift
//  YOUProfileInterfaces
//
//  Created by Ihar Karunny on 3/9/24.
//

import Foundation
import UIKit

public final class ProfileRouter {
    public var rootProfileVC: UINavigationController?
    public var rootReserveVC: UINavigationController?
    
    public static var shared = ProfileRouter()
    
    public func toEditProfile(onClose: @escaping (() -> Void)) {
        rootProfileVC?.pushViewController(ProfileScreenFactory.createProfileEditVC(onClose: onClose), animated: true)
    }
    
    public func toMenu(onClose: @escaping (() -> Void)) {
        rootProfileVC?.pushViewController(ProfileScreenFactory.createMenuVC(onClose: onClose), animated: true)
    }
    
    public func toLogin(onClose: @escaping (() -> Void)) {
        rootProfileVC?.popToRootViewController(animated: true)
    }
}
