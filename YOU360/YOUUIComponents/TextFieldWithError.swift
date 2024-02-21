//
//  TextFieldWithError.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/21/24.
//

import UIKit
import YOUUtils

public final class TextFieldWithError: UIView {
    
    public final class FieldError {
        private(set) var description: String
        
        init(description: String) {
            self.description = description
        }
    }
    
    public enum State {
        case `default`
        case typing
        case typed
        case error(error: FieldError)
        case disabled
    }
    
    private enum Constants {
        static let fieldHeight: CGFloat = 48
        static let fieldRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1
        
        static let errorLabelTextSize: CGFloat = 12
        static let errorLabelInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    private var setupComplete = false

    private lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: Constants.fieldHeight).isActive = true
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.fieldRadius
        return field
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = YOUFontsProvider.appMediumFont(with: Constants.errorLabelTextSize)
        label.textColor = ColorPallete.appRed
        return label
    }()

    private func setupUI() {
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(errorLabel)
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.errorLabelInsets.top).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.errorLabelInsets.bottom).isActive = true
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard !setupComplete else { return }
        setupUI()
        setupComplete = true
    }
    
    public func set(state: State) {
        
    }
}
