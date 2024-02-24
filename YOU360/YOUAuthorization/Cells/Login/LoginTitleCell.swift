//
//  LoginTitleCell.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/23/24.
//

import UIKit
import YOUUtils

final class LoginTitleCell: UITableViewCell {
    
    private enum Constants {
        static let titleFontSize: CGFloat = 22
        static let titleInsets = UIEdgeInsets(top: 18, left: 20, bottom: 0, right: 20)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "LoginTitle".localised()
        label.textColor = ColorPallete.appBlackSecondary
        label.font = YOUFontsProvider.appBoldFont(with: Constants.titleFontSize)
        label.textAlignment = .center
        return label
    }()
    
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
        
        contentView.addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.titleInsets.bottom).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.titleInsets.left).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.titleInsets.right).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.titleInsets.top).isActive = true
    }
}
