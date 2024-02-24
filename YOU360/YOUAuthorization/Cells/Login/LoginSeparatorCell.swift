//
//  LoginSeparatorCell.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/24/24.
//

import UIKit
import YOUUtils

final class LoginSeparatorCell: UITableViewCell {
    private enum Constants {
        static let cellHeight: CGFloat = 16
        static let labelFontSize: CGFloat = 11
        static let labelTextHorizontalInsets: CGFloat = 11
        static let lineHeight: CGFloat = 1
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = YOUFontsProvider.appBoldFont(with: Constants.labelFontSize)
        label.backgroundColor = ColorPallete.appWhiteSecondary
        label.textColor = ColorPallete.appGrey2
        label.text = "LoginOr".localised()
        return label
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: Constants.lineHeight).isActive = true
        line.backgroundColor = ColorPallete.appGrey2
        return line
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
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.heightAnchor.constraint(equalToConstant: Constants.cellHeight).isActive = true
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        containerView.addSubview(lineView)
        lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        lineView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        let labelContainer = UIView()
        labelContainer.backgroundColor = ColorPallete.appWhiteSecondary
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelContainer)
        labelContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        labelContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        labelContainer.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: Constants.labelTextHorizontalInsets).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor, constant: -Constants.labelTextHorizontalInsets).isActive = true
    }
}
