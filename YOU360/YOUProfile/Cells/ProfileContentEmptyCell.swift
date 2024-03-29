//
//  ProfileContentEmptyCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/29/24.
//

import UIKit
import YOUUtils

final class ProfileContentEmptyCell: UICollectionViewCell {
    private enum Constants {
        static let labelFont = YOUFontsProvider.appSemiBoldFont(with: 16)
        static let labelHorizontalOffset: CGFloat = 20
    }
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.labelFont
        label.textColor = ColorPallete.appGrey
        label.numberOfLines = 0
        label.textAlignment = .center
        contentView.addSubview(label)
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.labelHorizontalOffset).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.labelHorizontalOffset).isActive = true
        
        return label
    }()
    
    func apply(text: String?) {
        textLabel.text = text
    }
    
    static func height(for text: String?, with width: CGFloat) -> CGFloat {
        guard let text = text else { return .leastNormalMagnitude }
        let actualWidth = width - 2 * Constants.labelHorizontalOffset
        return ceil(TextSizeCalculator.calculateSize(with: actualWidth, text: text, font: Constants.labelFont).height)
    }
}
