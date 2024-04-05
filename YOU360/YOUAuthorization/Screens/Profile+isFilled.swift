//
//  Profile+isFilled.swift
//  YOUAuthorization
//
//  Created by Ihar Karunny on 4/5/24.
//

import Foundation
import YOUProfileInterfaces

extension Profile {
    var profileFilled: Bool {
        return name != nil ||
        surname != nil ||
        aboutMe != nil ||
        dateOfBirth != nil ||
        city != nil ||
//        paymentMethod != nil ||
        instagram != nil ||
        facebook != nil ||
        twitter != nil ||
        posts != 0 ||
        events != 0 ||
        establishments != 0 ||
        photoAvatarUrl != nil ||
        photoBackgroundUrl != nil
    }
}
