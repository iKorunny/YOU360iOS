//
//  ProfileManager.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/3/24.
//

import Foundation
import YOUUtils
import UIKit
import YOUNetworking
import YOUAuthorization

public final class ProfileManager {
    private enum Constants {
        static let isFilledProfileKey = "isFilledProfileKey"
    }
    
    public static var shared = {
        return ProfileManager()
    }()
    public var profile: UserInfoResponse? {
        didSet {
            saveProfile()
        }
    }
    public var avatar: UIImage?
    public var banner: UIImage?
    public var hasProfile: Bool {
        profile != nil
    }
    
    public var isAuthorized: Bool {
        AuthorizationService.shared.isAuthorized && hasProfile
    }
    
    public var isProfileEdited: Bool {
        set {
            UserDefaults.standard.setValue(newValue, 
                                           forKey: Constants.isFilledProfileKey)
        }
        get {
            UserDefaults.standard.bool(forKey: Constants.isFilledProfileKey)
        }
    }
    
    private var fileURL: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let profileFolder = path.appending(path: "MyProfile")
        
        if !FileManager.default.fileExists(atPath: profileFolder.path()) {
            try? FileManager.default.createDirectory(at: profileFolder, withIntermediateDirectories: true)
        }
        
        return profileFolder.appending(path: "MyProfileFile")
    }
    
    init() {
        loadProfile()
    }
    
    private func saveProfile() {
        guard let profile else { return }
        do {
            let jsonData = try JSONEncoder().encode(profile)
            try jsonData.write(to: fileURL)
        }
        catch let err {
            print("ProfileManager -> saveProfile() error: \(err) ")
        }
    }
    
    private func loadProfile() {
        guard FileManager.default.fileExists(atPath: fileURL.path()) else { return }
        do {
            let jsonData = try Data(contentsOf: fileURL)
            profile = try JSONDecoder().decode(UserInfoResponse.self, from: jsonData)
        }
        catch let err {
            print("ProfileManager -> loadProfile() error: \(err) ")
        }
    }
    
    public func deleteProfile() {
        avatar = nil
        banner = nil
        guard FileManager.default.fileExists(atPath: fileURL.path()) else { return }
        try? FileManager.default.removeItem(at: fileURL)
        DownloadCaches.getContentCache().removeAllCachedResponses()
    }
    
    public func set(profile: UserInfoResponse?) {
        self.profile = profile
        self.isProfileEdited = profile?.profileFilled ?? false
    }
    
    public func applyUpdate(updatedProfile: UserInfoResponse) {
        profile?.postsCount = updatedProfile.postsCount
        saveProfile()
    }
}

extension UserInfoResponse {
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
        postsCount != 0 ||
        likedEventsCount != 0 ||
        establishmentsSubscriptionsCount != 0 ||
        avatarId != nil ||
        backgroundId != nil
    }
}
