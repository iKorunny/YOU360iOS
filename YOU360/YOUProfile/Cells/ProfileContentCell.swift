//
//  ProfileContentCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/30/24.
//

import UIKit
import YOUUtils

final class ProfileContentCell: UICollectionViewCell {
    
    var cellModel: ProfilePostCellModel? {
        didSet {
            oldValue?.cell = nil
            cellModel?.loadImageIfNeeded()
        }
    }
    
    private lazy var imageContentView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        return imageView
    }()
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
    }
    
    func setup() {
        contentView.backgroundColor = ColorPallete.appWhite
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = Constants.cornerRadius
    }
    
    func set(image: UIImage?) {
        imageContentView.image = image
    }
    
    static func size(with width: CGFloat, offset: CGFloat, interitemSpacing: CGFloat, numbeOfItemsPerLine: Int) -> CGSize {
        let cellWidth = floor((width - (offset * 2 + interitemSpacing * CGFloat(numbeOfItemsPerLine - 1))) / CGFloat(numbeOfItemsPerLine))
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
