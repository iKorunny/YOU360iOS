//
//  MenuCell.swift
//  YOUProfile
//
//  Created by Andrey Matoshko on 10.04.24.
//

import UIKit
import YOUUtils

final class MenuCell: UITableViewCell {
    private var menuContentView: MenuItemContentView?
    
    func apply(viewModel: MenuContentViewModel) {
        selectionStyle = .none
        
        if menuContentView == nil {
            let menuView = MenuItemContentView(viewModel: viewModel)
            menuView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(menuView)
            menuView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
            menuView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            menuView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
            menuView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            menuView.layer.cornerRadius = 12
            menuView.clipsToBounds = true
            menuContentView = menuView
        }
        
        menuContentView?.apply(viewModel: viewModel)
    }
    

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        backgroundColor = .clear
    }
}
