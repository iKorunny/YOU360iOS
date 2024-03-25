//
//  ProfileInfoCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/24/24.
//

import UIKit

final class ProfileInfoCell: UICollectionViewCell {
    private var infoContentView: ProfileInfoContentView?
    
    func apply(viewModel: ProfileInfoContentViewModel) {
        if infoContentView == nil {
            let infoView = ProfileInfoContentView()
            infoView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(infoView)
            infoView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            infoContentView = infoView
        }
        
        infoContentView?.apply(viewModel: viewModel)
    }
    
    static func calculateHeight(from width: CGFloat, model: ProfileInfoContentViewModel) -> CGFloat {
        return ProfileInfoContentView.calculateHeight(from: width, model: model)
    }
}
