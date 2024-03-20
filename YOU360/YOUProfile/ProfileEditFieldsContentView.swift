//
//  ProfileEditFieldsContentView.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/10/24.
//

import UIKit
import YOUUtils

enum ProfileEditFieldModelType {
    case keyboard
    case date
}

protocol ProfileEditFieldActionsDelegate: AnyObject {
    func willShowPicker(for type: ProfileEditFieldModelType) -> Bool
    
    func onShouldBeginEditing(for type: ProfileEditFieldModelType)
    func onShouldEndEditing(for type: ProfileEditFieldModelType)
}

final class ProfileEditFieldModel: NSObject {
    let identifier: String
    
    let type: ProfileEditFieldModelType
    
    let placeholder: String
    let placeholderFont: UIFont
    let placeholderColor: UIColor
    
    var text: String?
    let textFont: UIFont
    let textColor: UIColor
    
    weak var textField: UITextField?
    
    private weak var actionsDelegate: ProfileEditFieldActionsDelegate?
    
    init(identifier: String, 
         type: ProfileEditFieldModelType = .keyboard,
         placeholder: String,
         placeholderFont: UIFont,
         placeholderColor: UIColor,
         text: String?,
         textFont: UIFont,
         textColor: UIColor,
         actionsDelegate: ProfileEditFieldActionsDelegate?) {
        self.identifier = identifier
        self.type = type
        self.placeholder = placeholder
        self.placeholderFont = placeholderFont
        self.placeholderColor = placeholderColor
        self.text = text
        self.textFont = textFont
        self.textColor = textColor
        self.actionsDelegate = actionsDelegate
        super.init()
    }
}

extension ProfileEditFieldModel: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        actionsDelegate?.onShouldBeginEditing(for: type)
        guard let actionsDelegate else { return true }
        return !actionsDelegate.willShowPicker(for: type)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        actionsDelegate?.onShouldEndEditing(for: type)
        return true
    }
}

final class ProfileEditFieldsContentViewModel: ProfileEditScreenFieldModel {
    var indexPath: IndexPath?
    
    var isFirstResponder: Bool {
        return self.fieldModels.contains(where: { $0.textField?.isFirstResponder == true })
    }
    
    func resignActive() {
        fieldModels.forEach { $0.textField?.resignFirstResponder() }
    }
    
    let fieldModels: [ProfileEditFieldModel]
    
    init(fieldModels: [ProfileEditFieldModel]) {
        self.fieldModels = fieldModels
    }
}

final class ProfileEditFieldsContentView: UIView {
    private enum Constants {
        static let containerCornerRadius: CGFloat = 16
        static let containerInsets: UIEdgeInsets = .init(top: 12, left: 20, bottom: 0, right: 20)
        
        static let textFieldHeight: CGFloat = 48
        static let textFieldOffset: CGFloat = 16
        static let fieldsSeparatorHeight: CGFloat = 1
    }
    
    private var viewModel: ProfileEditFieldsContentViewModel?
    
    private lazy var fieldsContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorPallete.appWhite
        container.layer.masksToBounds = true
        container.layer.cornerRadius = Constants.containerCornerRadius
        let heightConstraint = container.heightAnchor.constraint(equalToConstant: .zero)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
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
    }
    
    private func setupUI() {
        guard let fieldsModels = viewModel?.fieldModels, !fieldsModels.isEmpty else { return }
        addSubview(fieldsContainer)
        
        fieldsContainer.topAnchor.constraint(equalTo: topAnchor, constant: Constants.containerInsets.top).isActive = true
        fieldsContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        fieldsContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.containerInsets.left).isActive = true
        fieldsContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.containerInsets.right).isActive = true
        
        var previousView: UIView?
        fieldsModels.forEach { fieldModel in
            guard let firstModel = fieldsModels.first,
                  let lastModel = fieldsModels.last else { return }
            let field = textField(for: fieldModel)
            let isFirst = firstModel === fieldModel
            let isLast = lastModel === fieldModel
            
            fieldsContainer.addSubview(field)
            
            field.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
            
            if isFirst {
                field.topAnchor.constraint(equalTo: fieldsContainer.topAnchor).isActive = true
            }
            else if let previousView {
                let separator = UIView()
                fieldsContainer.addSubview(separator)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.backgroundColor = ColorPallete.appWeakPink
                separator.heightAnchor.constraint(equalToConstant: Constants.fieldsSeparatorHeight).isActive = true
                separator.leadingAnchor.constraint(equalTo: previousView.leadingAnchor).isActive = true
                separator.trailingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
                separator.topAnchor.constraint(equalTo: previousView.bottomAnchor).isActive = true
                
                field.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
            }
            
            if isLast {
                field.bottomAnchor.constraint(equalTo: fieldsContainer.bottomAnchor).isActive = true
            }
            
            field.leadingAnchor.constraint(equalTo: fieldsContainer.leadingAnchor, constant: Constants.textFieldOffset).isActive = true
            field.trailingAnchor.constraint(equalTo: fieldsContainer.trailingAnchor, constant: -Constants.textFieldOffset).isActive = true
            previousView = field
        }
    }
    
    private func textField(for model: ProfileEditFieldModel) -> UITextField {
        let field = UITextField()
        field.backgroundColor = ColorPallete.appWhite
        field.attributedPlaceholder = NSAttributedString(string: model.placeholder, attributes: [
            .font: model.placeholderFont,
            .foregroundColor: model.placeholderColor
        ])
        
        field.text = model.text
        field.textColor = model.textColor
        field.font = model.textFont
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = model
        
        model.textField = field
        
        return field
    }
}
