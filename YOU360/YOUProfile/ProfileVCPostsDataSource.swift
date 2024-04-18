//
//  ProfileVCPostsDataSource.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 4/14/24.
//

import Foundation
import UIKit
import YOUProfileInterfaces
import YOUNetworking

final class ProfileVCPostsDataSource {
    private let collectionView: UICollectionView
    private var posts: [ProfileContent] = []
    
    var numberOfPosts: Int {
        ProfileManager.shared.profile?.posts ?? 0
    }
    
    var shouldShowLoadingFooter: Bool = true
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func cellModel(for index: Int) -> ProfilePostCellModel? {
        guard index < posts.count else { return nil }
        let post = posts[index]
        return ProfilePostCellModel(id: post.id, urlString: post.previewUrl)
    }
    
    func postModel(for index: Int) -> ProfileContent? {
        guard index < posts.count else { return nil }
        return posts[index]
    }
    
    func reloadContent(userId: String, page: RequestPage, completion: @escaping ((Bool, SecretPartNetworkLocalError?) -> Void)) {
        ProfileNetworkService().makeProfileMediaRequest(id: userId, page: page) { [weak self] success, content, localError in
            if success {
                self?.posts = content ?? []
            }
            completion(success, localError)
        }
    }
}
