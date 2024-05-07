//
//  SafeStorage.swift
//  AnalysClient
//
//  Created by Igor Korunny on 14.05.21.
//

import Foundation
import Security

public final class SafeStorage: NSObject {
	
	private static let tokenKey = "AuthTokenKey"
    private static let refreshTokenKey = "RefreshTokenKey"
	
	private static let userLoginKey = "UserLoginKey"
	private static let userPasKey = "userPasKey"
	
	public static func saveAuthToken(_ token: String) {
		if KeychainService.load(key: tokenKey) == nil {
			_ = KeychainService.save(key: tokenKey, data: token)
		}
		else {
			_ = KeychainService.update(key: tokenKey, data: token)
		}
	}
	
	public static func getAuthToken() -> String? {
		return KeychainService.load(key: tokenKey)
	}
	
	public static func removeAuthToken() {
		KeychainService.remove(key: tokenKey)
	}
    
    public static func saveRefreshToken(_ token: String) {
        if KeychainService.load(key: refreshTokenKey) == nil {
            _ = KeychainService.save(key: refreshTokenKey, data: token)
        }
        else {
            _ = KeychainService.update(key: refreshTokenKey, data: token)
        }
    }
    
    public static func getRefreshToken() -> String? {
        return KeychainService.load(key: refreshTokenKey)
    }
    
    public static func removeRefreshToken() {
        KeychainService.remove(key: refreshTokenKey)
    }
	
	public static func saveUserLogin(_ login: String) {
		if KeychainService.load(key: userLoginKey) == nil {
			_ = KeychainService.save(key: userLoginKey, data: login)
		}
		else {
			_ = KeychainService.update(key: userLoginKey, data: login)
		}
	}
	
    public static func clear() {
		removeAuthToken()
        removeRefreshToken()
	}
}
