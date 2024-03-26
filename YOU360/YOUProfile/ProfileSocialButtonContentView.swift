//
//  ProfileSocialButtonContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/26/24.
//

import UIKit
import YOUUIComponents
import YOUUtils

enum ProfileSocialButtonType {
    case facebook
    case instagram
    case x
}

final class ProfileSocialButtonModel {
    let type: ProfileSocialButtonType
    let url: URL
    
    init(type: ProfileSocialButtonType, url: URL) {
        self.type = type
        self.url = url
    }
}

final class ProfileSocialButtonContentViewModel {
    let socials: [ProfileSocialButtonModel]
    let action: ((URL) -> Void)
    
    init(socials: [ProfileSocialButtonModel], action: @escaping (URL) -> Void) {
        self.socials = socials
        self.action = action
    }
}

final class ProfileSocialButtonContentView: UIView {
    
    private enum Constants {
        static let stackSpacing: CGFloat = 10
        static let stackHeight: CGFloat = 40
        static let stackOffset: CGFloat = 20
        
        static let buttonCornerRadius: CGFloat = 12
    }
    
    private var viewModel: ProfileSocialButtonContentViewModel?

    func apply(viewModel: ProfileSocialButtonContentViewModel) {
        subviews.forEach { $0.removeFromSuperview() }
        self.viewModel = viewModel
        
        let stackView = UIStackView(arrangedSubviews: buttons(from: viewModel.socials))
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = Constants.stackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackOffset).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.stackOffset).isActive = true
    }

    @objc private func onPressButton(sender: UIView) {
        guard let viewModel else { return }
        let index = sender.tag
        guard viewModel.socials.count > index else { return }
        viewModel.action(viewModel.socials[index].url)
    }
    
    private func buttons(from socials: [ProfileSocialButtonModel]) -> [UIButton] {
        var buttons: [UIButton] = []
        for i in 0..<socials.count {
            let social = socials[i]
            
            var image: UIImage?
            switch social.type {
            case .facebook:
                image = UIImage(named: "ProfileSocialFacebookIcon")
            case .instagram:
                image = UIImage(named: "ProfileSocialInstagramIcon")
            case .x:
                image = UIImage(named: "ProfileSocialXIcon")
            }
            
            let button = ButtonsFactory.createIconButton(icon: image,
                                                         backgroundColor: ColorPallete.appWhite,
                                                         cornerRadius: Constants.buttonCornerRadius,
                                                         highlightColor: ColorPallete.appDarkPink,
                                                         target: self,
                                                         action: #selector(onPressButton(sender:)))
            button.tag = i
            buttons.append(button)
            button.heightAnchor.constraint(equalToConstant: Constants.stackHeight).isActive = true
        }
        
        return buttons
    }
}
