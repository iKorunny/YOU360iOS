//
//  ProfileHeaderCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/8/24.
//

import UIKit

final class ProfileHeaderCell: UICollectionViewCell {
    private var profileContentView: ProvileHeaderContentView?
    
    func apply(viewModel: ProvileHeaderContentViewModel) {
        if profileContentView == nil {
            let profileView = ProvileHeaderContentView()
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
