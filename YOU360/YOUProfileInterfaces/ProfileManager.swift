//
//  ProfileManager.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/3/24.
//

import Foundation

public final class ProfileManager {
    public static var shared = {
        return ProfileManager()
    }()
    public var profile: Profile?
    public var isProfileEdited: Bool {
        return false
    }
}
