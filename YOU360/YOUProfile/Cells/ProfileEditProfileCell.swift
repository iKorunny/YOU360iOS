//
//  ProfileEditProfileCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/9/24.
//

import UIKit

final class ProfileEditProfileCell: UICollectionViewCell {
    private enum Constants {
        static let defaultHeight: CGFloat = 190
    }
    
    private var editProfileContentView: ProfileEditCellContentView?
    
    func apply(viewModel: ProfileEditCellContentViewModel) {
        
        if editProfileContentView == nil {
            let editProfileView = ProfileEditCellContentView()
            editProfileView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(editProfileView)
            editProfileView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            editProfileView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            editProfileView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            editProfileView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            editProfileContentView = editProfileView
        }
        
        editProfileContentView?.apply(viewModel: viewModel)
    }
    
    func height(with width: CGFloat) -> CGFloat {
        return ProfileEditCellContentView.height(with: width)
    }
}
