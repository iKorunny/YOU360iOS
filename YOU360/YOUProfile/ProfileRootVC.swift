//
//  ProfileRootVC.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/1/24.
//

import UIKit
import YOUUtils

final class ProfileRootVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItem()
    }
    
    private func setupTabBarItem() {
        tabBarItem.title = "ProfileTabBarTitle".localised()
        tabBarItem.image = UIImage(named: "ProfileTabBarItemDefault")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "ProfileTabBarItemSelected")?.withRenderingMode(.alwaysOriginal)
    }
}
