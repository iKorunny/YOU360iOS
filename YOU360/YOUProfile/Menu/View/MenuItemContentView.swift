//
//  MenuItemContentView.swift
//  YOUProfile
//
//  Created by Andrey Matoshko on 14.04.24.
//

import UIKit
import YOUUtils

final class MenuItemContentView: UIView {
    
    // MARK: Constants
    
    private enum Constants {
        static let leftIconOffset: CGFloat = 16
        static let leftIconHeight: CGFloat = 24
        static let leftIconWidth: CGFloat = 24
        
        static let rightIconOffset: CGFloat = 16
        static let rightIconHeight: CGFloat = 24
        static let rightIconWidth: CGFloat = 24
        
        static let profileIconHeight: CGFloat = 55
        static let profileIconWidth: CGFloat = 55
        static let profileTitleOffset: CGFloat = 55
        static let profileTitleFont = YOUFontsProvider.appSemiBoldFont(with: 18)
        static let profileTitleHeigth: CGFloat = 25
        static let profileSubFont = YOUFontsProvider.appSemiBoldFont(with: 14)
        
        static let textLeadingOffset: CGFloat = 8
        static let textHeight: CGFloat = 19
        static let textFont = YOUFontsProvider.appSemiBoldFont(with: 14)
        static let mainTextColor = ColorPallete.appBlackSecondary
        static let subTextColor = ColorPallete.appGrey
        
        static let switchKeyColor = ColorPallete.appPink
        static let switchKeyOffColor = ColorPallete.appDarkGrey
        static let switchKeyThumbColor = ColorPallete.appWhite
        
        static let logOutTextColor = ColorPallete.appRed
        static let logOutHightlightAlpha = 0.7
    }
    
    // MARK: UI
    
    private(set) lazy var rightIconView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "CellOpenScreenIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.widthAnchor.constraint(equalToConstant: Constants.leftIconWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.rightIconWidth).isActive = true
        imageView.contentMode = .center
        return imageView
    }()
    
    private(set) lazy var leftIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private(set) lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textAlignment = .left
        label.font = Constants.textFont
        label.textColor = Constants.mainTextColor
        return label
    }()
    
    private(set) lazy var subTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textAlignment = .left
        label.font = Constants.profileSubFont
        label.textColor = Constants.subTextColor
        label.heightAnchor.constraint(equalToConstant: Constants.textHeight).isActive = true
        return label
    }()
    
    private(set) lazy var infoTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textAlignment = .left
        label.font = Constants.textFont
        label.textColor = Constants.subTextColor
        label.heightAnchor.constraint(equalToConstant: Constants.textHeight).isActive = true
        return label
    }()
    
    private lazy var button: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(highlight), for: .touchDragInside)
        button.addTarget(self, action: #selector(highlight), for: .touchDown)
        button.addTarget(self, action: #selector(unHighlight), for: .touchDragOutside)
        button.addTarget(self, action: #selector(unHighlight), for: .touchCancel)
        button.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var switchButton: UISwitch = {
       let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.thumbTintColor = Constants.switchKeyThumbColor
        switchButton.onTintColor = Constants.switchKeyColor
        switchButton.tintColor = Constants.switchKeyOffColor
        return switchButton
    }()

    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        
        
        stackView.addSubview(mainTextLabel)
        stackView.addSubview(subTextLabel)
        
        mainTextLabel.font = Constants.profileTitleFont
        subTextLabel.topAnchor.constraint(equalTo: self.mainTextLabel.bottomAnchor).isActive = true
        
        return stackView
    }()
    
    private var viewModel: MenuContentViewModel?
    
    // MARK: Inits
    
    convenience init(viewModel: MenuContentViewModel) {
        self.init(frame: .zero, viewModel: viewModel)
    }
    
    init(frame: CGRect, viewModel: MenuContentViewModel) {
        super.init(frame: frame)
        self.viewModel = viewModel
        didLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didLoad() {
        setupUI()
    }
    
    private func setupUI() {
        addSubview(leftIconView)
        addSubview(infoTextLabel)
        
        if viewModel?.type == .profile {
            addSubview(profileStackView)
        } else {
            addSubview(mainTextLabel)
        }
        
        if viewModel?.type == .switchKey {
            addSubview(switchButton)
        } else {
            addSubview(rightIconView)
            
        }
        
        addSubview(button)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        setupLayout()
    }
    
    private func setupLayout() {
        leftIconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leftIconOffset).isActive = true
        leftIconView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.leftIconOffset).isActive = true
        leftIconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.leftIconOffset).isActive = true
        
        if viewModel?.type == .profile {
            leftIconView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.leftIconOffset).isActive = true
            leftIconView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.leftIconOffset).isActive = true
            leftIconView.widthAnchor.constraint(equalToConstant: Constants.profileIconWidth).isActive = true
            leftIconView.heightAnchor.constraint(equalToConstant: Constants.profileIconHeight).isActive = true
            
            profileStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.leftIconOffset).isActive = true
            profileStackView.leadingAnchor.constraint(equalTo: leftIconView.trailingAnchor, constant: Constants.textLeadingOffset).isActive = true
            mainTextLabel.heightAnchor.constraint(equalToConstant: Constants.profileTitleHeigth).isActive = true
            
        } else {
            leftIconView.widthAnchor.constraint(equalToConstant: Constants.leftIconWidth).isActive = true
            leftIconView.heightAnchor.constraint(equalToConstant: Constants.leftIconHeight).isActive = true
            mainTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            mainTextLabel.leadingAnchor.constraint(equalTo: leftIconView.trailingAnchor, constant: Constants.textLeadingOffset).isActive = true
        }
        
        if viewModel?.type == .switchKey {
            switchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            switchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.rightIconOffset).isActive = true
        } else {
            rightIconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            rightIconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.rightIconOffset).isActive = true
        }
        
        if viewModel?.type == .dropdown {
            rightIconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            rightIconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.rightIconOffset).isActive = true
            infoTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            infoTextLabel.trailingAnchor.constraint(equalTo: rightIconView.leadingAnchor, constant: -Constants.textLeadingOffset).isActive = true
        }
        
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    func apply(viewModel: MenuContentViewModel) {
        mainTextLabel.text = viewModel.mainText
        infoTextLabel.text = viewModel.infoText
        subTextLabel.text = viewModel.subText
        leftIconView.image = viewModel.icon
        
        switch viewModel.type {
        case .logOut:
            backgroundColor = ColorPallete.appDarkWhite
            mainTextLabel.textColor = Constants.logOutTextColor
            rightIconView.isHidden = true
            
        default:
            backgroundColor = ColorPallete.appWhite
        }
        
        updateConstraints()
    }
    
    @objc private func highlight() {
        if viewModel?.type == .logOut {
            leftIconView.alpha = Constants.logOutHightlightAlpha
            mainTextLabel.alpha = Constants.logOutHightlightAlpha
            return
        }
        self.backgroundColor = ColorPallete.appDarkWhite
    }


    @objc private func unHighlight() {
        if viewModel?.type == .logOut {
            leftIconView.alpha = 1
            mainTextLabel.alpha = 1
            return
        }
        
        self.backgroundColor = ColorPallete.appWhite
    }

    @objc private func playAction() {
        unHighlight()
        viewModel?.action()
        
        if viewModel?.type == .switchKey {
            switchButton.setOn(!switchButton.isOn, animated: true)
        }
    }
    
}
