//
//  ProfileRootVC.swift
//  YOUNavigationController
//
//  Created by Ihar Karunny on 3/1/24.
//

import UIKit
import YOUUtils

public enum YOUNavigationControllerItemType: Int {
    case home
    case top
    case chat
    case reserve
    case you
    
    func title() -> String? {
        switch self {
        case .home:
            return "HomeTabBarTitle".localised()
        case .top:
            return "TopTabBarTitle".localised()
        case .chat:
            return "ChatTabBarTitle".localised()
        case .reserve:
            return "ReserveTabBarTitle".localised()
        case .you:
            return "ProfileTabBarTitle".localised()
        }
    }
    
    func iconDefault() -> UIImage? {
        switch self {
        case .home:
            return UIImage(named: "HomeTabBarItemDefault")?.withRenderingMode(.alwaysOriginal)
        case .top:
            return UIImage(named: "TopTabBarItemDefault")?.withRenderingMode(.alwaysOriginal)
        case .chat:
            return UIImage(named: "ChatTabBarItemNoInboxDefault")?.withRenderingMode(.alwaysOriginal)
        case .reserve:
            return UIImage(named: "ReserveTabBarItemDefault")?.withRenderingMode(.alwaysOriginal)
        case .you:
            return UIImage(named: "ProfileTabBarItemDefault")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func iconSelected() -> UIImage? {
        switch self {
        case .home:
            return UIImage(named: "HomeTabBarItemSelected")?.withRenderingMode(.alwaysOriginal)
        case .top:
            return UIImage(named: "TopTabBarItemSelected")?.withRenderingMode(.alwaysOriginal)
        case .chat:
            return UIImage(named: "ChatTabBarItemNoInboxSelected")?.withRenderingMode(.alwaysOriginal)
        case .reserve:
            return UIImage(named: "ReserveTabBarItemSelected")?.withRenderingMode(.alwaysOriginal)
        case .you:
            return UIImage(named: "ProfileTabBarItemSelected")?.withRenderingMode(.alwaysOriginal)
        }
    }
}

public final class YOUNavigationController: UINavigationController {
    
    let type: YOUNavigationControllerItemType

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItem()
    }
    
    public init(rootViewController: UIViewController, type: YOUNavigationControllerItemType) {
        self.type = type
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBarItem() {
        tabBarItem.title = type.title()
        tabBarItem.image = type.iconDefault()
        tabBarItem.selectedImage = type.iconSelected()
    }
}
