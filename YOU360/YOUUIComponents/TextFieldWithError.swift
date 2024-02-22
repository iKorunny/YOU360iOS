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
        static let fieldIconsPaddingOut: CGFloat = 16
        static let fieldIconsPaddingIn: CGFloat = 8
        
        static let errorLabelTextSize: CGFloat = 12
        static let errorLabelInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    private var setupComplete = false

    private lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: Constants.fieldHeight).isActive = true
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.fieldRadius
        field.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return field
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = YOUFontsProvider.appMediumFont(with: Constants.errorLabelTextSize)
        label.textColor = ColorPallete.appRed
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
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
        errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        errorLabel.text = "This is concrete error message"
        textField.backgroundColor = .gray
        textField.leftView = fieldLeftView(named: "InputEmailIndicator")
        textField.rightView = fieldLeftView(named: "InputSecureShow")
        textField.leftViewMode = .always
        textField.rightViewMode = .always
    }
    
    private func fieldLeftView(named: String) -> UIView {
        let image = UIImage(named: named)
        let imageSize = image?.size ?? .zero
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .center
        
        let outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(imageView)
        outerView.frame = CGRect(origin: .zero, size: CGSize(width: imageSize.width + Constants.fieldIconsPaddingOut + Constants.fieldIconsPaddingIn, height: imageSize.height))
        
        imageView.frame.origin = CGPoint(x: Constants.fieldIconsPaddingOut, y: 0)
        
        return outerView
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
