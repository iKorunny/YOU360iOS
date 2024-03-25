//
//  ProfileEditCellContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/9/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class ProfileEditCellContentViewModel {
    var onEdit: (() -> Void)
    
    init(onEdit: @escaping () -> Void) {
        self.onEdit = onEdit
    }
}

final class ProfileEditCellContentView: UIView {
    
    private enum Constants {
        static let titleFontSize: CGFloat = 22
        static let titleLabelInsets: UIEdgeInsets = .init(top: 32, left: 20, bottom: -8, right: -20)
        
        static let descriptionFontSize: CGFloat = 14
        
        static let buttonTitleSize: CGFloat = 16
        static let buttonTopOffset: CGFloat = 24
        
        static let editButtonHeight: CGFloat = 56
        static let titleLabelText: String = "ProfileEditCellTitle".localised()
        static let descriptionLabelText: String = "ProfileEditCellDescription".localised()
        static let titleLabelFont: UIFont = YOUFontsProvider.appBoldFont(with: Constants.titleFontSize)
        static let descriptionLabelFont: UIFont = YOUFontsProvider.appRegularFont(with: Constants.descriptionFontSize)
    }
    
    private var viewModel: ProfileEditCellContentViewModel?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = Constants.titleLabelFont
        label.textColor = ColorPallete.appBlackSecondary
        label.text = Constants.titleLabelText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Constants.descriptionLabelFont
        label.textColor = ColorPallete.appBlackSecondary
        label.text = Constants.descriptionLabelText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = ButtonsFactory.createButton(
            backgroundColor: ColorPallete.appPink,
            highlightedBackgroundColor: ColorPallete.appDarkPink,
            title: "ProfileEditCellButtonTitle".localised(),
            titleFont: YOUFontsProvider.appBoldFont(with: Constants.buttonTitleSize),
            titleColor: ColorPallete.appWhite,
            target: self,
            action: #selector(onEdit)
        )
        return button
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
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(editButton)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        setupLayout()
    }
    
    private func setupLayout() {
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLabelInsets.left).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.titleLabelInsets.right).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleLabelInsets.top).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: Constants.titleLabelInsets.bottom).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        editButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        editButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        editButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        editButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.buttonTopOffset).isActive = true
    }
    
    func apply(viewModel: ProfileEditCellContentViewModel) {
        self.viewModel = viewModel
    }
    
    @objc private func onEdit() {
        viewModel?.onEdit()
    }
    
    static func height(with width: CGFloat) -> CGFloat {
        var height = Constants.titleLabelInsets.top + (-Constants.titleLabelInsets.bottom) + Constants.buttonTopOffset + Constants.editButtonHeight
        let calculatedTitleHeight = TextSizeCalculator.calculateSize(with: width, text: Constants.titleLabelText, font: Constants.titleLabelFont).height
        let calculatedDescriptionHeight = TextSizeCalculator.calculateSize(with: width, text: Constants.descriptionLabelText, font: Constants.descriptionLabelFont).height
        height += calculatedTitleHeight
        height += calculatedDescriptionHeight
        
        return ceil(height)
    }
}
