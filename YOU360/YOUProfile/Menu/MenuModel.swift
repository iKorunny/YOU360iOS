//
//  MenuModel.swift
//  YOUProfile
//
//  Created by Andrey Matoshko on 12.04.24.
//

import UIKit

enum MenuItemType {
    case profile
    case standart
    case switchKey
    case logOut
}

protocol MenuItem {
    
}

enum MenuItemIcons {
    static let moon = UIImage(named: "MenuMoonIcon")
    static let notifications = UIImage(named: "MenuNotificationIcon")
    static let payment = UIImage(named: "MenuPaymentIcon")
    static let profile = UIImage(named: "MenuProfileIcon")
    static let distance = UIImage(named: "MenuDistanceIcon")
    static let history = UIImage(named: "MenuHistoryIcon")
    static let logOut = UIImage(named: "MenuLogOutIcon")
    static let help = UIImage(named: "MenuHelpCenterIcon")
    static let report = UIImage(named: "MenuReportIcon")
    static let mock = UIImage(named: "MenuMock")
}

struct MenuItemRegular: MenuItem {
    let title: String
    let type: MenuItemType
    var subTitle: String?
    var icon: UIImage?
    var action: (() -> Void)?
}
