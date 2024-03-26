//
//  ProfileVCViewModel.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/8/24.
//

import Foundation
import YOUProfileInterfaces
import UIKit

protocol ProfileVCViewModel {
    var myProfile: Bool { get }
    var isProfileFilled: Bool { get }
    
    func set(collectionView: UICollectionView)
}

final class MyProfileVCViewModelImpl: NSObject, ProfileVCViewModel {
    private enum Constants {
        static let profileHeaderId = "ProfileHeaderCell"
        static let profileEditCellId = "ProfileEditProfileCell"
        static let profileInfoCellId = "ProfileInfoCell"
        static let profileSocialButtonsCellId = "ProfileSocialButtonsCell"
    }
    
    var myProfile: Bool { return true }
    var isProfileFilled: Bool { return profileManager.isProfileEdited }
    
    private weak var collectionView: UICollectionView?
    
    private var profileManager: ProfileManager
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    func set(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: Constants.profileHeaderId)
        collectionView.register(ProfileEditProfileCell.self, forCellWithReuseIdentifier: Constants.profileEditCellId)
        collectionView.register(ProfileInfoCell.self, forCellWithReuseIdentifier: Constants.profileInfoCellId)
        collectionView.register(ProfileSocialButtonsCell.self, forCellWithReuseIdentifier: Constants.profileSocialButtonsCellId)
    }
    
    private func infoViewModel(from pofile: Profile?) -> ProfileInfoContentViewModel? {
//        guard let profile = profileManager.profile else { return nil }
        
        let date = Calendar.current.date(byAdding: .year, value: -25, to: Date())
        return ProfileInfoContentViewModel(name: "Lucas Bailey",
                                           desciption: ("🔘" + " I do business in the club industry for 17 years.\n" + "🔘" + " I was the CCO of many international projects."),
                                           address: "Paris, France",
                                           dateOfBirth: date, 
                                           isVerified: true)
    }
    
    private func socialsModel(from profile: Profile?) -> ProfileSocialButtonContentViewModel? {
        return ProfileSocialButtonContentViewModel(socials: [
            .init(type: .facebook, url: URL(string: "https://www.instagram.com/ikorunny?igsh=MTVxZnVyZGVxM3lqcw%3D%3D&utm_source=qr")!),
            .init(type: .instagram, url: URL(string: "https://www.instagram.com/ikorunny?igsh=MTVxZnVyZGVxM3lqcw%3D%3D&utm_source=qr")!),
            .init(type: .x, url: URL(string: "https://www.instagram.com/ikorunny?igsh=MTVxZnVyZGVxM3lqcw%3D%3D&utm_source=qr")!)
        ]) { url in
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    private func toEditProfile() {
        ProfileRouter.shared.toEditProfile { [weak self] in
            self?.collectionView?.reloadSections([1])
        }
        profileManager.isProfileEdited = true
    }
}


extension MyProfileVCViewModelImpl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return isProfileFilled ? 2 : 1
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileHeaderId, for: indexPath) as! ProfileHeaderCell
            let profileHeaderViewModel = ProvileHeaderContentViewModel(
                profile: ProfileManager.shared.profile,
                onlineIdicator: .init(isHidden: false, status: .online)) { [weak self] in
                    self?.toEditProfile()
                } onShare: {
                    print("MyProfileVCViewModelImpl -> OnShare")
                }

            cell.apply(viewModel: profileHeaderViewModel)
            return cell
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                if !isProfileFilled {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileEditCellId, for: indexPath) as! ProfileEditProfileCell
                    cell.apply(viewModel: .init(onEdit: { [weak self] in
                        self?.toEditProfile()
                    }))
                    return cell
                }
                else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileInfoCellId, for: indexPath) as! ProfileInfoCell
                    if let model = infoViewModel(from: profileManager.profile) {
                        cell.apply(viewModel: model)
                    }
                    
                    return cell
                }
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileSocialButtonsCellId, for: indexPath) as! ProfileSocialButtonsCell
                if let model = socialsModel(from: profileManager.profile) {
                    cell.apply(viewModel: model)
                }
                
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.window?.bounds.width ?? .leastNormalMagnitude
        if indexPath.section == 0 {
            let height = ProvileHeaderContentView.calculateHeight(from: width)
            return CGSize(width: width, height: height)
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                if !isProfileFilled {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileEditCellId, for: indexPath) as! ProfileEditProfileCell
                    return CGSize(width: width, height: cell.height(with: width))
                }
                else {
                    guard let infoModel = infoViewModel(from: profileManager.profile) else { return CGSize.zero }
                    
                    return CGSize(width: width,
                                  height: ProfileInfoCell.calculateHeight(from: width, model: infoModel))
                }
            case 1:
                return CGSize(width: width, height: ProfileSocialButtonsCell.height())
            default:
                return .zero
            }
        }
        else {
            return CGSize.zero
        }
    }
}
