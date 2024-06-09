//
//  MenuContentViewModel.swift
//  YOUProfile
//
//  Created by Andrey Matoshko on 14.04.24.
//

import UIKit

protocol MenuContentViewModel {
    var mainText: String? { get }
    var subText: String? { get }
    var infoText: String? { get }
    var isEnabled: Bool? { get }
    var icon: UIImage? { get }
    var type: MenuItemType { get }
    
    func action()
    func reload()
}

final class MenuContentViewModelImpl: MenuContentViewModel {
    
    // MARK: Public
    
    var mainText: String? { model.title }
    var subText: String? { model.subTitle }
    var infoText: String? { nil }
    var isEnabled: Bool? { nil }
    var icon: UIImage? { model.icon }
    var type: MenuItemType { model.type }
    var reloadAction: (() -> Void)?
    
    // MARK: Private
    
    private let model: MenuItemRegular
    
    init(item: MenuItemRegular, reloadAction: (() -> Void)? = nil) {
        self.model = item
        self.reloadAction = reloadAction
    }
    
    func action() {
        model.action?()
    }
    
    func reload() {
        reloadAction?()
    }
    
    
}
