//
//  AuthorizationService.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation
import YOUUtils
import YOUProfileInterfaces

public final class AuthorizationService {
    public static var shared = {
        AuthorizationService()
    }()
    
    public var isAuthorized: Bool {
        token != nil && refreshToken != nil && ProfileManager.shared.hasProfile
    }
    
    var token: String? {
        set {
            if let token = newValue {
                SafeStorage.saveAuthToken(token)
            }
            else {
                SafeStorage.removeAuthToken()
            }
        }
        
        get {
            SafeStorage.getAuthToken()
        }
    }
    
    var refreshToken: String? {
        set {
            if let token = newValue {
                SafeStorage.saveRefreshToken(token)
            }
            else {
                SafeStorage.removeRefreshToken()
            }
            loginObservers.forEach { $0.closure() }
        }
        
        get {
            SafeStorage.getRefreshToken()
        }
    }
    
    private var loginObservers: [ClosureObserver] = []
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: .onLogout, object: nil)
    }
    
    public func observeLoginStatus(callback: @escaping (() -> Void)) -> AnyObject? {
        let observer = ClosureObserver(closure: callback)
        loginObservers.append(observer)
        return observer
    }
    
    public func removeLogin(observer: AnyObject?) {
        guard let observer = observer else { return }
        loginObservers.removeAll(where: { $0 === observer })
    }
    
    @objc public func onLogout() {
        ProfileManager.shared.deleteProfile()
        SafeStorage.clear()
        loginObservers.forEach { $0.closure() }
    }
}
