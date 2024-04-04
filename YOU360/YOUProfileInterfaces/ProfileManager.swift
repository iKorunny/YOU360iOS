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
    public var profile: Profile? {
        didSet {
            saveProfile()
        }
    }
    public var isProfileEdited: Bool = false
    
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
            profile = try JSONDecoder().decode(Profile.self, from: jsonData)
        }
        catch let err {
            print("ProfileManager -> loadProfile() error: \(err) ")
        }
    }
    
    public func deleteProfile() {
        guard FileManager.default.fileExists(atPath: fileURL.path()) else { return }
        try? FileManager.default.removeItem(at: fileURL)
    }
}
