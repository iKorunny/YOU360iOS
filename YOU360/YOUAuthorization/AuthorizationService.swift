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
            loginObservers.forEach { $0.closure() }
        }
        
        get {
            SafeStorage.getToken()
        }
    }
    
    private var loginObservers: [ClosureObserver] = []
    
    public func observeLoginStatus(callback: @escaping (() -> Void)) -> AnyObject? {
        let observer = ClosureObserver(closure: callback)
        loginObservers.append(observer)
        return observer
    }
    
    public func removeLogin(observer: AnyObject?) {
        guard let observer = observer else { return }
        loginObservers.removeAll(where: { $0 === observer })
    }
}

private final class ClosureObserver {
    let closure: (() -> Void)
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
}
