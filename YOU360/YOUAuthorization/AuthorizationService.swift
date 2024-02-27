//
//  AuthorizationService.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import YOUUtils

public final class AuthorizationService {
    public static var shared = {
        AuthorizationService()
    }()
    
    public var isAuthorized: Bool {
        token != nil
    }
    
    var token: String? {
        set {
            if let token = newValue {
                SafeStorage.saveAuthToken(token)
            }
            else {
                SafeStorage.removeToken()
            }
        }
        
        get {
            SafeStorage.getToken()
        }
    }
    
    private var loginObservers: [LoginObserver] = []
    
    public func observeLogin(callback: @escaping ((Bool) -> Void)) -> AnyObject? {
        let observer = LoginObserver(closure: callback)
        loginObservers.append(observer)
        return observer
    }
    
    public func removeLogin(observer: AnyObject?) {
        guard let observer = observer else { return }
        loginObservers.removeAll(where: { $0 === observer })
    }
}

private final class LoginObserver {
    let closure: ((Bool) -> Void)
    
    init(closure: @escaping (Bool) -> Void) {
        self.closure = closure
    }
}
