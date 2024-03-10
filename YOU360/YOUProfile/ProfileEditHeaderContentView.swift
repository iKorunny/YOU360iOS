//
//  ProfileEditHeaderContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/10/24.
//

import UIKit
import YOUUtils
import YOUUIComponents
import YOUProfileInterfaces


final class ProfileEditHeaderContentViewModel {
    var profile: Profile?
    
    init(profile: Profile?) {
        self.profile = profile
    }
}

final class ProfileEditHeaderContentView: UIView {
    private enum Constants {
        static let avatarBackgroundBottomOffset: CGFloat = 30
        
        static let avatarSize: CGSize = .init(width: 120, height: 120)
        static let avatarLeadingOffset: CGFloat = 20
        static let avatarBorderWidth: CGFloat = 2
        static let avatarCornerRadius: CGFloat = 30
    }
    
    private var viewModel: ProfileEditHeaderContentViewModel?
    
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
    }
    
    func apply(viewModel: ProfileEditHeaderContentViewModel) {
        self.viewModel = viewModel
    }
    
    static func calculateHeight(from width: CGFloat) -> CGFloat {
        return width / 375 * 222 + Constants.avatarBackgroundBottomOffset
    }
}
