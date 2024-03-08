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
    }
}


extension MyProfileVCViewModelImpl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.profileHeaderId, for: indexPath) as! ProfileHeaderCell
            let profileHeaderViewModel = ProvileHeaderContentViewModel(
                profile: ProfileManager.shared.profile ?? Profile(),
                onlineIdicator: .init(isHidden: false, status: .online)) {
                    print("MyProfileVCViewModelImpl -> OnEdit")
                } onShare: {
                    print("MyProfileVCViewModelImpl -> OnShare")
                }

            cell.apply(viewModel: profileHeaderViewModel)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = collectionView.window?.bounds.width ?? .leastNormalMagnitude
            let height = ProvileHeaderContentView.calculateHeight(from: width)
            return CGSize(width: width, height: height)
        }
        else {
            return CGSize.zero
        }
    }
}
