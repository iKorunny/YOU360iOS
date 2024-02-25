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
        
        public init(description: String) {
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
        
        static let placeholderSize: CGFloat = 14
        static let textSize: CGFloat = 14
    }
    
    public var isEmpty: Bool {
        (textField.text ?? "").isEmpty
    }
    
    public var isSecure: Bool {
        return textField.isSecureTextEntry
    }
    
    private var setupComplete = false
    private var state: State = .default
    
    private lazy var secureControlTapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(onSecureControl))
    }()

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
        
        textField.font = YOUFontsProvider.appMediumFont(with: Constants.textSize)
        
        updateColors()
        
        addSubview(errorLabel)
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.errorLabelInsets.top).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
    
    private func fieldRightView(named: String) -> UIView {
        let image = UIImage(named: named)
        let imageSize = image?.size ?? .zero
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .center
        
        let outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(imageView)
        outerView.frame = CGRect(origin: .zero, size: CGSize(width: imageSize.width + Constants.fieldIconsPaddingOut + Constants.fieldIconsPaddingIn, height: imageSize.height))
        
        imageView.frame.origin = CGPoint(x: Constants.fieldIconsPaddingIn, y: 0)
        
        return outerView
    }
    
    @objc private func onSecureControl() {
        set(secureInput: !textField.isSecureTextEntry, showControl: true)
    }
    
    public func set(delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
    
    public func setupLeftImage(named: String) {
        textField.leftView = fieldLeftView(named: named)
        textField.leftViewMode = .always
        textField.leftView?.tintColor = leftImageTintColor(for: state)
    }
    
    public func setupRightImage(named: String) {
        textField.rightView = fieldRightView(named: named)
        textField.rightViewMode = .always
        textField.rightView?.tintColor = rightImageTintColor(for: state)
    }
    
    public func set(placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor : ColorPallete.appGrey,
            .font : YOUFontsProvider.appMediumFont(with: Constants.placeholderSize)
        ])
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard !setupComplete else { return }
        setupUI()
        setupComplete = true
    }
    
    public func set(state: State) {
        self.state = state
        updateColors()
    }
    
    public func set(secureInput: Bool, showControl: Bool = false) {
        textField.isSecureTextEntry = secureInput
        textField.rightView?.removeGestureRecognizer(secureControlTapRecognizer)
        textField.rightView = nil
        textField.rightViewMode = .never
        
        guard showControl else { return }
        textField.rightView = fieldRightView(named: secureInput ? "InputSecureHide" : "InputSecureShow")
        textField.rightView?.addGestureRecognizer(secureControlTapRecognizer)
        textField.rightViewMode = .always
        textField.rightView?.tintColor = rightImageTintColor(for: state)
    }
    
    public func hideKeyboard() {
        textField.resignFirstResponder()
    }
    
    public func equal(to field: UITextField) -> Bool {
        return textField === field
    }
    
    public func setRightView(visible: Bool) {
        textField.rightViewMode = visible ? .always : .never
        guard textField.rightView == nil else { return }
        set(secureInput: textField.isSecureTextEntry, showControl: visible)
    }
    
    private func leftImageTintColor(for state: State) -> UIColor {
        switch state {
        case .typing:
            return ColorPallete.appPink
        case .error(error: _):
            return ColorPallete.appRed
        case .disabled:
            return ColorPallete.appGrey
        default:
            return ColorPallete.appBlackSecondary
        }
    }
    
    private func rightImageTintColor(for state: State) -> UIColor {
        return ColorPallete.appBlackSecondary
    }
    
    private func updateColors() {
        
        textField.tintColor = ColorPallete.appBlackSecondary
        textField.backgroundColor = fieldBackgroundColor(for: state)
        textField.rightView?.tintColor = rightImageTintColor(for: state)
        textField.leftView?.tintColor = leftImageTintColor(for: state)
        textField.textColor = textColor(for: state)
        textField.layer.borderWidth = Constants.borderWidth
        textField.layer.borderColor = borderColor(for: state).cgColor
        
        switch state {
        case .disabled:
            textField.alpha = 0.5
            errorLabel.text = nil
        case .error(error: let err):
            textField.alpha = 1.0
            errorLabel.text = err.description
        default:
            textField.alpha = 1.0
            errorLabel.text = nil
        }
    }
    
    private func fieldBackgroundColor(for state: State) -> UIColor {
        switch state {
        case .error(error: _):
            return ColorPallete.appRed.withAlphaComponent(0.05)
        default:
            return ColorPallete.appWhite
        }
    }
    
    private func textColor(for state: State) -> UIColor {
        switch state {
        case .error(error: _):
            return ColorPallete.appRed
        default:
            return ColorPallete.appBlackSecondary
        }
    }
    
    private func borderColor(for state: State) -> UIColor {
        switch state {
        case .typing:
            return ColorPallete.appPink
        case .typed:
            return ColorPallete.appGreySecondary
        case .error(error: _):
            return ColorPallete.appRed
        default:
            return ColorPallete.appWhite
        }
    }
}
