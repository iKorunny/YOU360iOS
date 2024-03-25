//
//  ProfileInfoIconWithTextView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/25/24.
//

import UIKit
import YOUUtils

final class ProfileInfoIconWithTextViewModel {
    let image: UIImage?
    let text: String?
    
    init(image: UIImage?, text: String?) {
        self.image = image
        self.text = text
    }
}

final class ProfileInfoIconWithTextView: UIView {
    
    private enum Constants {
        static let labelFont: UIFont = YOUFontsProvider.appMediumFont(with: 14)
        static let labelLeftOffset: CGFloat = 8
        static let labelHeight: CGFloat = 19
    }

    private var viewModel: ProfileInfoIconWithTextViewModel?
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = Constants.labelFont
        label.textColor = ColorPallete.appBlackSecondary
        label.textAlignment = .left
        return label
    }()
    
    convenience init(model: ProfileInfoIconWithTextViewModel) {
        self.init(frame: .zero, model: model)
    }
    
    init(frame: CGRect, model: ProfileInfoIconWithTextViewModel) {
        super.init(frame: frame)
        self.viewModel = model
        didLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didLoad() {
        setupUI()
    }
    
    private func setupUI() {
        guard let viewModel else { return }
        
        addSubview(iconView)
        iconView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(textLabel)
        textLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.labelLeftOffset).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight).isActive = true
        
        apply(model: viewModel)
    }
    
    func apply(model: ProfileInfoIconWithTextViewModel) {
        iconView.image = model.image
        textLabel.text = model.text
    }
    
    static func height() -> CGFloat {
        return Constants.labelHeight
    }
}
