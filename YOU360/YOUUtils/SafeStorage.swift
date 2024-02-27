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
	
	public static func getToken() -> String? {
		return KeychainService.load(key: tokenKey)
	}
	
	public static func removeToken() {
		KeychainService.remove(key: tokenKey)
	}
	
	public static func saveUserLogin(_ login: String) {
		if KeychainService.load(key: userLoginKey) == nil {
			_ = KeychainService.save(key: userLoginKey, data: login)
		}
		else {
			_ = KeychainService.update(key: userLoginKey, data: login)
		}
	}
	
	public static func getUserLogin() -> String? {
		return KeychainService.load(key: userLoginKey)
	}
	
	public static func removeUserLogin() {
		KeychainService.remove(key: userLoginKey)
	}
	
    public static func saveUserPassword(_ password: String) {
		if KeychainService.load(key: userPasKey) == nil {
			_ = KeychainService.save(key: userPasKey, data: password)
		}
		else {
			_ = KeychainService.update(key: userPasKey, data: password)
		}
	}
	
    public static func getUserPassword() -> String? {
		return KeychainService.load(key: userPasKey)
	}
	
    public static func removeUserPassword() {
		KeychainService.remove(key: userPasKey)
	}
	
    public static func clear() {
		removeToken()
		removeUserLogin()
		removeUserPassword()
	}
}
