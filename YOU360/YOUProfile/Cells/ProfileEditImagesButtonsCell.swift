//
//  ProfileEditImagesButtonsCell.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/10/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class ProfileEditImagesButtonsCellViewModel {
    var onChooseAvatar: (() -> Void)
    var onChooseBanner: (() -> Void)
    
    init(onChooseAvatar: @escaping () -> Void, 
         onChooseBanner: @escaping () -> Void) {
        self.onChooseAvatar = onChooseAvatar
        self.onChooseBanner = onChooseBanner
    }
}

final class ProfileEditImagesButtonsCell: UITableViewCell {
    
    private enum Constants {
        static let buttonsHeight: CGFloat = 48
        
        static let buttonsOffset: CGFloat = 20
        static let buttonsSpacing: CGFloat = 15
        
        static let buttonsTextSize: CGFloat = 14
        
        static let buttonsBottomOffset: CGFloat = 12
        static let buttonsTopOffset: CGFloat = 53
    }
    
    private var viewModel: ProfileEditImagesButtonsCellViewModel?
    
    private lazy var buttonsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight).isActive = true
        
        let centerView = UIView()
        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.backgroundColor = .clear
        view.addSubview(centerView)
        centerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerView.widthAnchor.constraint(equalToConstant: Constants.buttonsSpacing).isActive = true
        
        let leftButtonContainer = UIView()
        leftButtonContainer.backgroundColor = .clear
        leftButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftButtonContainer)
        leftButtonContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leftButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonsOffset).isActive = true
        leftButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftButtonContainer.trailingAnchor.constraint(equalTo: centerView.leadingAnchor).isActive = true
        
        leftButtonContainer.addSubview(chooseAvatarButton)
        chooseAvatarButton.leadingAnchor.constraint(equalTo: leftButtonContainer.leadingAnchor).isActive = true
        chooseAvatarButton.trailingAnchor.constraint(equalTo: leftButtonContainer.trailingAnchor).isActive = true
        chooseAvatarButton.topAnchor.constraint(equalTo: leftButtonContainer.topAnchor).isActive = true
        chooseAvatarButton.bottomAnchor.constraint(equalTo: leftButtonContainer.bottomAnchor).isActive = true
        
        let rightButtonContainer = UIView()
        rightButtonContainer.backgroundColor = .clear
        rightButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightButtonContainer)
        rightButtonContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightButtonContainer.leadingAnchor.constraint(equalTo: centerView.trailingAnchor).isActive = true
        rightButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rightButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonsOffset).isActive = true
        
        rightButtonContainer.addSubview(chooseBannerButton)
        chooseBannerButton.leadingAnchor.constraint(equalTo: rightButtonContainer.leadingAnchor).isActive = true
        chooseBannerButton.trailingAnchor.constraint(equalTo: rightButtonContainer.trailingAnchor).isActive = true
        chooseBannerButton.topAnchor.constraint(equalTo: rightButtonContainer.topAnchor).isActive = true
        chooseBannerButton.bottomAnchor.constraint(equalTo: rightButtonContainer.bottomAnchor).isActive = true
        
        return view
    }()
    
    private lazy var chooseAvatarButton: UIButton = {
        let button = ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appWhite,
            highlightedBackgroundColor: ColorPallete.appDarkWhite,
            title: "ProfileEditChooseAvatarTitle".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.buttonsTextSize),
            titleColor: ColorPallete.appPink,
            height: Constants.buttonsHeight,
            target: self,
            action: #selector(onChooseAvatar)
            )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var chooseBannerButton: UIButton = {
        let button = ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appWhite,
            highlightedBackgroundColor: ColorPallete.appDarkWhite,
            title: "ProfileEditChooseBannerTitle".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.buttonsTextSize),
            titleColor: ColorPallete.appPink,
            height: Constants.buttonsHeight,
            target: self,
            action: #selector(onChooseAvatar)
            )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        contentView.addSubview(buttonsContainer)
        buttonsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        buttonsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        buttonsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.buttonsBottomOffset).isActive = true
        buttonsContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.buttonsTopOffset).isActive = true
    }

    @objc private func onChooseAvatar() {
        viewModel?.onChooseAvatar()
    }
    
    @objc private func onChooseBanner() {
        viewModel?.onChooseBanner()
    }
    
    func apply(viewModel: ProfileEditImagesButtonsCellViewModel) {
        self.viewModel = viewModel
    }
}
