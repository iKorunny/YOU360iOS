//
//  ProfileHeaderContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 6/8/24.
//

import UIKit
import YOUUtils
import YOUUIComponents
import YOUNetworking

final class ProvileHeaderContentViewModel {
    var profile: UserInfoResponse?
    var avatar: UIImage?
    var banner: UIImage?
    var onlineIdicator: OnlineIndicator
    
    var onShare: (() -> Void)
    
    init(profile: UserInfoResponse?,
         onlineIdicator: OnlineIndicator,
         avatar: UIImage?,
         banner: UIImage?,
         onShare: @escaping () -> Void) {
        self.profile = profile
        self.avatar = avatar
        self.banner = banner
        self.onlineIdicator = onlineIdicator
        self.onShare = onShare
    }
}

final class ProvileHeaderContentView: UIView {
    private enum Constants {
        static let avatarBackgroundBottomOffset: CGFloat = 30
        static let avatarBackgroundHeightMultiplier: CGFloat = 222 / 375
        
        static let avatarSize: CGSize = .init(width: 120, height: 120)
        static let avatarLeadingOffset: CGFloat = 20
        static let avatarBorderWidth: CGFloat = 2
        static let avatarCornerRadius: CGFloat = 30
        
        static let buttonsTrailingOffset: CGFloat = 20
        static let buttonsBottomOffset: CGFloat = 12
        static let shareButtonSize: CGFloat = 32
        static let shareButtonTitleSize: CGFloat = 14
        static let shareButtonIconPadding: CGFloat = 4
        
        static let onlineIndicatorHeight: CGFloat = 22
        static let onlineIndicatorTitleHorizontalOffset: CGFloat = 8
        static let onlineIndicatorTextSize: CGFloat = 10
        
        static let avatarPlaceholder = UIImage(named: "ProfileAvatarPlaceholder")
        static let bannerPlaceholder = UIImage(named: "ProfileBackgroundPlaceholder")
    }
    
    private var viewModel: ProvileHeaderContentViewModel?
    
    private(set) lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: Constants.avatarPlaceholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private(set) lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: Constants.avatarPlaceholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: Constants.avatarSize.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.avatarSize.height).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = Constants.avatarBorderWidth
        imageView.layer.cornerRadius = Constants.avatarCornerRadius
        imageView.layer.borderColor = ColorPallete.appWhiteSecondary.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private(set) lazy var shareButton = {
        let button = ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appWhite,
            highlightedBackgroundColor: ColorPallete.appDarkWhite,
            title: "ProfileShareButtonTitle".localised(),
            titleFont: YOUFontsProvider.appMediumFont(with: Constants.shareButtonTitleSize),
            titleColor: ColorPallete.appPink,
            titleIcon: UIImage(named: "ProfileShare"),
            iconPadding: Constants.shareButtonIconPadding,
            height: Constants.shareButtonSize,
            cornerRadius: Constants.shareButtonSize * 0.5,
            target: self,
            action: #selector(onShare)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var onlineIndicatorContainer = {
        let container = UIView()
        container.backgroundColor = .clear
        container.clipsToBounds = false
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: .zero).isActive = true
        container.heightAnchor.constraint(equalToConstant: Constants.onlineIndicatorHeight).isActive = true
        return container
    }()
    
    private lazy var onlineIndicatorBackgroundView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = Constants.onlineIndicatorHeight * 0.5
        backgroundView.isHidden = true
        return backgroundView
    }()
    
    private lazy var onlineIndicatorLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPallete.appWhite3
        label.font = YOUFontsProvider.appBoldFont(with: Constants.onlineIndicatorTextSize)
        label.numberOfLines = 1
        return label
    }()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didLoad() {
        setupUI()
    }
    
    private func setupUI() {
        addSubview(backgroundImageView)
        addSubview(avatarImageView)
        addSubview(shareButton)
        addSubview(onlineIndicatorContainer)
        onlineIndicatorContainer.addSubview(onlineIndicatorBackgroundView)
        onlineIndicatorContainer.addSubview(onlineIndicatorLabel)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.avatarBackgroundBottomOffset).isActive = true
        let backgroundHeight = backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: Constants.avatarBackgroundHeightMultiplier)
        backgroundHeight.priority = .defaultHigh
        backgroundHeight.isActive = true
        
        avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.avatarLeadingOffset).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        shareButton.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -Constants.buttonsBottomOffset).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -Constants.buttonsTrailingOffset).isActive = true
        
        onlineIndicatorContainer.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor).isActive = true
        onlineIndicatorContainer.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor).isActive = true
        
        onlineIndicatorBackgroundView.heightAnchor.constraint(equalTo: onlineIndicatorContainer.heightAnchor).isActive = true
        onlineIndicatorBackgroundView.centerXAnchor.constraint(equalTo: onlineIndicatorContainer.centerXAnchor).isActive = true
        onlineIndicatorBackgroundView.centerYAnchor.constraint(equalTo: onlineIndicatorContainer.centerYAnchor).isActive = true
        
        onlineIndicatorLabel.leadingAnchor.constraint(equalTo: onlineIndicatorBackgroundView.leadingAnchor, constant: Constants.onlineIndicatorTitleHorizontalOffset).isActive = true
        onlineIndicatorLabel.trailingAnchor.constraint(equalTo: onlineIndicatorBackgroundView.trailingAnchor, constant: -Constants.onlineIndicatorTitleHorizontalOffset).isActive = true
        onlineIndicatorLabel.centerYAnchor.constraint(equalTo: onlineIndicatorBackgroundView.centerYAnchor).isActive = true
        onlineIndicatorLabel.centerXAnchor.constraint(equalTo: onlineIndicatorBackgroundView.centerXAnchor).isActive = true
    }
    
    @objc private func onShare() {
        viewModel?.onShare()
    }
    
    func apply(viewModel: ProvileHeaderContentViewModel) {
        self.viewModel = viewModel
        onlineIndicatorBackgroundView.isHidden = viewModel.onlineIdicator.isHidden
        onlineIndicatorBackgroundView.backgroundColor = viewModel.onlineIdicator.statusColor
        onlineIndicatorLabel.text = viewModel.onlineIdicator.statusStringRepresentation
        avatarImageView.image = viewModel.avatar ?? Constants.avatarPlaceholder
        backgroundImageView.image = viewModel.banner ?? Constants.bannerPlaceholder
    }
    
    static func calculateHeight(from width: CGFloat) -> CGFloat {
        return width / 375 * 222 + Constants.avatarBackgroundBottomOffset
    }
}
