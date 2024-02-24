//
//  LoginSocialNetworksProvider.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 2/24/24.
//

import Foundation
import UIKit

enum LoginSocialNetwork: String {
    case google = "Google"
    case apple = "Apple"
    case facebook = "Facebook"
    case vk = "VK"
    
    func logoImage() -> UIImage? {
        switch self {
        case .google:
            return UIImage(named: "loginGoogle")
        case .apple:
            return UIImage(named: "loginApple")
        case .facebook:
            return UIImage(named: "loginFacebook")
        default:
            return nil
        }
    }
}

final class LoginSocialNetworksProvider {
    static func supportedNetworks() -> [LoginSocialNetwork] {
        guard let region = Locale.current.region else { return [] }
        
        switch region.identifier {
        case "RU":
            return [.google, .apple]
        default:
            return [.google, .apple, .facebook]
        }
    }
}
