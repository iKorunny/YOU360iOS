//
//  MyProfileHeaderCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/8/24.
//

import UIKit

final class MyProfileHeaderCell: UICollectionViewCell {
    private var profileContentView: MyProvileHeaderContentView?
    
    func apply(viewModel: MyProvileHeaderContentViewModel) {
        if profileContentView == nil {
            let profileView = MyProvileHeaderContentView()
            profileView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(profileView)
            profileView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            profileView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            profileView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            profileView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            profileContentView = profileView
        }
        
        profileContentView?.apply(viewModel: viewModel)
    }
}
