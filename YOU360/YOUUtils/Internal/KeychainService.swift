//
//  KeychainService.swift
//  AnalysClient
//
//  Created by Igor Korunny on 14.05.21.
//

import Foundation

class KeychainService {
	class func save(key: String, data: String) -> OSStatus {
		let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false)!
		let query = [kSecClass as String : kSecClassGenericPassword as String,
					 kSecAttrAccount as String : key,
					 kSecValueData as String : dataFromString] as [String : Any]
		
		SecItemDelete(query as CFDictionary)
		
		return SecItemAdd(query as CFDictionary, nil)
	}
	
	class func update(key: String, data: String) -> OSStatus {
		let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false)!
		let query = [kSecClass as String : kSecClassGenericPassword as String,
					 kSecAttrAccount as String : key] as [String : Any]
		
		SecItemUpdate(query as CFDictionary, [kSecValueData as String : dataFromString] as CFDictionary)
		
		return SecItemAdd(query as CFDictionary, nil)
	}
	
	class func load(key: String) -> String? {
		let query = [kSecClass as String : kSecClassGenericPassword,
					 kSecAttrAccount as String : key,
					 kSecReturnData as String : kCFBooleanTrue!,
					 kSecMatchLimit as String : kSecMatchLimitOne ] as [String : Any]
		
		var dataTypeRef: AnyObject? = nil
		
		let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
		
		if status == noErr {
			return String(data: dataTypeRef as! Data, encoding: .utf8)
		} else {
			return nil
		}
	}
	
	class func remove(key: String) {
		
		let query = [kSecClass as String : kSecClassGenericPassword as String,
					 kSecAttrAccount as String : key] as [String : Any]
		
		// Delete any existing items
		let status = SecItemDelete(query as CFDictionary)
		if (status != errSecSuccess) {
			if let err = SecCopyErrorMessageString(status, nil) {
				print("Remove failed: \(err)")
			}
		}
	}
	
	class func createUniqueID() -> String {
		let uuid: CFUUID = CFUUIDCreate(nil)
		let cfStr: CFString = CFUUIDCreateString(nil, uuid)
		
		let swiftString: String = cfStr as String
		return swiftString
	}
}
