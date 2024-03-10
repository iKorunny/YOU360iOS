//
//  ProfileEditFieldsContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/10/24.
//

import UIKit
import YOUUtils

final class ProfileEditFieldModel {
    let identifier: String
    
    let placeholder: String
    let placeholderFont: UIFont
    let placeholderColor: UIColor
    
    var text: String?
    let textFont: UIFont
    let textColor: UIColor
    
    init(identifier: String, 
         placeholder: String,
         placeholderFont: UIFont,
         placeholderColor: UIColor,
         text: String?,
         textFont: UIFont,
         textColor: UIColor) {
        self.identifier = identifier
        self.placeholder = placeholder
        self.placeholderFont = placeholderFont
        self.placeholderColor = placeholderColor
        self.text = text
        self.textFont = textFont
        self.textColor = textColor
    }
}

final class ProfileEditFieldsContentViewModel {
    let fieldModels: [ProfileEditFieldModel]
    
    init(fieldModels: [ProfileEditFieldModel]) {
        self.fieldModels = fieldModels
    }
}

final class ProfileEditFieldsContentView: UIView {
    private enum Constants {
        static let containerCornerRadius: CGFloat = 16
        static let containerInsets: UIEdgeInsets = .init(top: 12, left: 20, bottom: 0, right: 20)
    }
    
    private var viewModel: ProfileEditFieldsContentViewModel?
    
    private lazy var fieldsContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorPallete.appWhite
        container.layer.masksToBounds = true
        container.layer.cornerRadius = Constants.containerCornerRadius
        return container
    }()
    
    convenience init(viewModel: ProfileEditFieldsContentViewModel) {
        self.init(frame: .zero, viewModel: viewModel)
    }
    
    init(frame: CGRect, viewModel: ProfileEditFieldsContentViewModel) {
        super.init(frame: frame)
        self.viewModel = viewModel
        didLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didLoad() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        guard let fieldsModels = viewModel?.fieldModels, !fieldsModels.isEmpty else { return }
        addSubview(fieldsContainer)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        setupLayout()
    }
    
    private func setupLayout() {
        fieldsContainer.topAnchor.constraint(equalTo: topAnchor, constant: Constants.containerInsets.top).isActive = true
        fieldsContainer.bottomAnchor.constraint(equalTo: topAnchor).isActive = true
        fieldsContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.containerInsets.left).isActive = true
        fieldsContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.containerInsets.right).isActive = true
    }
    
    private func textField(for model: ProfileEditFieldModel) -> UITextField {
        let field = UITextField()
        field.backgroundColor = ColorPallete.appWhite
        field.attributedPlaceholder = NSAttributedString(string: model.placeholder, attributes: [
            .font: model.placeholderFont,
            .foregroundColor: model.placeholderColor.cgColor
        ])
        
        field.text = model.text
        field.textColor = model.textColor
        field.font = model.textFont
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
}
