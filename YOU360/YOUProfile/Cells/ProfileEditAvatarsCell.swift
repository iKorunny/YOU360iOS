//
//  ProfileEditAvatarsCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/10/24.
//

import UIKit
import YOUUtils

final class ProfileEditAvatarsCell: UITableViewCell {
    
    private var editProfileContentView: ProfileEditHeaderContentView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        selectionStyle = .none
    }
    
    func apply(viewModel: ProfileEditHeaderContentViewModel) {
        if editProfileContentView == nil {
            let editProfileView = ProfileEditHeaderContentView()
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
}
