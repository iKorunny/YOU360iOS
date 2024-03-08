//
//  LoginRegisterCell.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/24/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class LoginRegisterCell: UITableViewCell {
    private enum Constants {
        static let horizontalPadding: CGFloat = 20
        static let titleLabelFontSize: CGFloat = 11
        static let buttonTitleFontSize: CGFloat = 14
        static let buttonBottomOffset: CGFloat = 34
        static let buttonHeight: CGFloat = 40
    }
    
    private var action: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = YOUFontsProvider.appBoldFont(with: Constants.titleLabelFontSize)
        label.textColor = ColorPallete.appGrey2
        label.text = "LoginCreateAccountTitle".localised()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appWhiteSecondary,
            highlightedBackgroundColor: ColorPallete.appWhiteSecondary.withAlphaComponent(0.5),
            title: "LoginCreateAccountButtonTitle".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.buttonTitleFontSize),
            titleColor: ColorPallete.appPink,
            height: Constants.buttonHeight,
            target: self,
            action: #selector(buttonAction)
        )
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with action: @escaping (() -> Void)) {
        self.action = action
    }
    
    private func setupUI() {
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        
        contentView.addSubview(button)
        button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.buttonBottomOffset).isActive = true
    }
    
    @objc private func buttonAction() {
        action?()
    }
}
