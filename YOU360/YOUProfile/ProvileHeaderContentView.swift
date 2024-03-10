//
//  ProvileHeaderContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/8/24.
//

import UIKit
import YOUUtils
import YOUUIComponents
import YOUProfileInterfaces

enum OnlineIndicatorStatus: String {
    case online = "ProfileHeaderOnlineIndicatorOnline"
}

struct OnlineIndicator {
    var isHidden: Bool
    var status: OnlineIndicatorStatus
    var statusStringRepresentation: String { status.rawValue.localised() }
    var statusColor: UIColor {
        switch status {
        case .online:
            return ColorPallete.appGreenIndication
        }
    }
}

final class ProvileHeaderContentViewModel {
    var profile: Profile?
    var onlineIdicator: OnlineIndicator
    
    var onEdit: (() -> Void)
    var onShare: (() -> Void)
    
    init(profile: Profile?,
         onlineIdicator: OnlineIndicator,
         onEdit: @escaping () -> Void,
         onShare: @escaping () -> Void) {
        self.profile = profile
        self.onlineIdicator = onlineIdicator
        self.onEdit = onEdit
        self.onShare = onShare
    }
}

final class ProvileHeaderContentView: UIView {
    private enum Constants {
        static let avatarBackgroundBottomOffset: CGFloat = 30
        
        static let avatarSize: CGSize = .init(width: 120, height: 120)
        static let avatarLeadingOffset: CGFloat = 20
        static let avatarBorderWidth: CGFloat = 2
        static let avatarCornerRadius: CGFloat = 30
        
        static let buttonsTrailingOffset: CGFloat = 20
        static let buttonsBottomOffset: CGFloat = 12
        static let buttonsHorizontalSpacing: CGFloat = 10
        static let editButtonTextSize: CGFloat = 14
        static let editButtonTextInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        static let shareButtonSize: CGFloat = 32
        
        static let onlineIndicatorHeight: CGFloat = 22
        static let onlineIndicatorTitleHorizontalOffset: CGFloat = 8
        static let onlineIndicatorTextSize: CGFloat = 10
    }
    
    private var viewModel: ProvileHeaderContentViewModel?
    
    private(set) lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "ProfileBackgroundPlaceholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private(set) lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: "ProfileAvatarPlaceholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: Constants.avatarSize.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.avatarSize.height).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = Constants.avatarBorderWidth
        imageView.layer.cornerRadius = Constants.avatarCornerRadius
        imageView.layer.borderColor = ColorPallete.appWhiteSecondary.cgColor
        return imageView
    }()
    
    private(set) lazy var shareButton = {
        let button = ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appWhite,
            highlightedBackgroundColor: ColorPallete.appDarkWhite,
            titleIcon: UIImage(named: "ProfileEdit"),
            height: Constants.shareButtonSize,
            cornerRadius: Constants.shareButtonSize * 0.5,
            target: self,
            action: #selector(onShare)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var editButton = {
        let button = ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appWhite,
            highlightedBackgroundColor: ColorPallete.appDarkWhite,
            title: "ProfileHeaderEdit".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.editButtonTextSize),
            titleColor: ColorPallete.appPink,
            contentInsets: Constants.editButtonTextInsets,
            height: Constants.shareButtonSize,
            target: self,
            action: #selector(onEdit)
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
        addSubview(editButton)
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
        
        avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.avatarLeadingOffset).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        editButton.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -Constants.buttonsBottomOffset).isActive = true
        editButton.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -Constants.buttonsTrailingOffset).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: editButton.bottomAnchor).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -Constants.buttonsHorizontalSpacing).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: Constants.shareButtonSize).isActive = true
        
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
    
    @objc private func onEdit() {
        viewModel?.onEdit()
    }
    
    func apply(viewModel: ProvileHeaderContentViewModel) {
        self.viewModel = viewModel
        onlineIndicatorBackgroundView.isHidden = viewModel.onlineIdicator.isHidden
        onlineIndicatorBackgroundView.backgroundColor = viewModel.onlineIdicator.statusColor
        onlineIndicatorLabel.text = viewModel.onlineIdicator.statusStringRepresentation
    }
    
    static func calculateHeight(from width: CGFloat) -> CGFloat {
        return width / 375 * 222 + Constants.avatarBackgroundBottomOffset
    }
}
