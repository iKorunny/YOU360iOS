//
//  AppearanceConfigoration.swift
//  YOU360
//
//  Created by Ihar Karunny on 3/1/24.
//

import Foundation
import UIKit
import YOUUtils

final class AppearanceConfigoration {
    private enum Constants {
        enum TabBarItem {
            static let fontSize: CGFloat = 12
        }
    }
    
    static func configuretabBarItem() {
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([
            .foregroundColor : ColorPallete.appGrey,
            .font : YOUFontsProvider.appSemiBoldFont(with: Constants.TabBarItem.fontSize)
        ], for: .normal)
        appearance.setTitleTextAttributes([
            .foregroundColor : ColorPallete.appPink,
            .font : YOUFontsProvider.appSemiBoldFont(with: Constants.TabBarItem.fontSize)
        ], for: .selected)
    }
    
    static func configure() {
        configuretabBarItem()
    }
}
