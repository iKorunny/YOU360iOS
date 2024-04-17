//
//  Validators.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/17/24.
//

import Foundation

public enum StringValidatorResult {
    case success
    case invalidEmail
    case wrongPasswordLength
    case passwordsDoNotMatch
}

public protocol StringValidator {
    func validate(value: String?) -> StringValidatorResult
}

public final class EmailValidator: StringValidator {
    private let regex: String
    
    public init() {
        regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    }
    
    public func validate(value: String?) -> StringValidatorResult {
        guard let value = value else { return .invalidEmail }
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: value) ? .success : .invalidEmail
    }
}

public final class PasswordValidator: StringValidator {
    private let minLength: Int
    
    public init() {
        minLength = 4
    }
    
    public func validate(value: String?) -> StringValidatorResult {
        guard let value = value else { return .wrongPasswordLength }
        return value.count >= minLength ? .success : .wrongPasswordLength
    }
    
    public func isSame(password1: String?, password2: String?) -> StringValidatorResult {
        return password1 == password2 ? .success : .passwordsDoNotMatch
    }
}
