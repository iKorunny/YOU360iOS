//
//  ProfileSocialButtonsCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/26/24.
//

import UIKit
import YOUUtils

final class ProfileSocialButtonsCell: UICollectionViewCell {
    private var socialContentView: ProfileSocialButtonContentView?
    
    func apply(viewModel: ProfileSocialButtonContentViewModel) {
        if socialContentView == nil {
            let socialView = ProfileSocialButtonContentView()
            socialView.backgroundColor = ColorPallete.appWhiteSecondary
            socialView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(socialView)
            socialView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            socialView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            socialView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            socialView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            socialContentView = socialView
        }
        
        socialContentView?.apply(viewModel: viewModel)
    }
    
    static func height() -> CGFloat {
        return 64
    }
}
