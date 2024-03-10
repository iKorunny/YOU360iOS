//
//  ProfileEditScreenViewModel.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 3/10/24.
//

import Foundation
import UIKit
import YOUProfileInterfaces

protocol ProfileEditScreenViewModel {
    func set(tableView: UITableView)
}

final class ProfileEditScreenViewModelImpl: NSObject, ProfileEditScreenViewModel {
    private enum Constants {
        static let avatarsCellID = "ProfileEditAvatarsCell"
        static let imageButtonsCellID = "ProfileEditImagesButtonsCell"
    }
    
    private weak var table: UITableView?
    
    let profileManager: ProfileManager
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    func set(tableView: UITableView) {
        self.table = tableView
        registerCells(for: tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerCells(for tableView: UITableView) {
        tableView.register(ProfileEditAvatarsCell.self, forCellReuseIdentifier: Constants.avatarsCellID)
        tableView.register(ProfileEditImagesButtonsCell.self, forCellReuseIdentifier: Constants.imageButtonsCellID)
    }
    
    private func deactivateInputFields() {
        
    }
}

extension ProfileEditScreenViewModelImpl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.avatarsCellID, for: indexPath) as! ProfileEditAvatarsCell
            cell.apply(viewModel: ProfileEditHeaderContentViewModel(profile: profileManager.profile))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.imageButtonsCellID, for: indexPath) as! ProfileEditImagesButtonsCell
            cell.apply(viewModel: ProfileEditImagesButtonsCellViewModel(onChooseAvatar: {
                print("ProfileEditScreenViewModelImpl -> onChooseAvatar")
            }, onChooseBanner: {
                print("ProfileEditScreenViewModelImpl -> onChooseBanner")
            }))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        deactivateInputFields()
    }
}
