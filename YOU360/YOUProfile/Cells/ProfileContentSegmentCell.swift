//
//  ProfileContentSegmentCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/28/24.
//

import UIKit
import YOUUtils

final class ProfileContentSegmentCell: UICollectionViewCell {
    private var content: ProfileContentSegmentContentView?
    
    func apply(viewModel: ProfileContentSegmentContentViewModel) {
        if content == nil {
            let newContentView = ProfileContentSegmentContentView()
            newContentView.backgroundColor = ColorPallete.appWhiteSecondary
            newContentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(newContentView)
            newContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            newContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            newContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            newContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            content = newContentView
        }
        
        content?.apply(viewModel: viewModel)
    }
    
    static func height() -> CGFloat {
        return 64
    }
}
