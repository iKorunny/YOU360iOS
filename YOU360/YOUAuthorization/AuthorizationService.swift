//
//  AuthorizationService.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation

public final class AuthorizationService {
    static var shared = {
        AuthorizationService()
    }()
    
    var isAuthorized: Bool {
        false
    }
}
