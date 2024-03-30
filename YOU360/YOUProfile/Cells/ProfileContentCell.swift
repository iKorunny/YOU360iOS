//
//  ProfileContentCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/30/24.
//

import UIKit
import YOUUtils

final class ProfileContentCell: UICollectionViewCell {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
    }
    
    func setup() {
        contentView.backgroundColor = ColorPallete.appWhite
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = Constants.cornerRadius
    }
    
    static func size(with width: CGFloat, offset: CGFloat, interitemSpacing: CGFloat, numbeOfItemsPerLine: Int) -> CGSize {
        let cellWidth = floor((width - (offset * 2 + interitemSpacing * CGFloat(numbeOfItemsPerLine - 1))) / CGFloat(numbeOfItemsPerLine))
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
