//
//  ProfileVCPostsDataSource.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 4/14/24.
//

import Foundation
import UIKit
import YOUAuthorization
import YOUNetworking

final class ProfileVCPostsDataSource {
    private let collectionView: UICollectionView
    private var posts: [ProfileContent] = []
    
    var numberOfPosts: Int {
        ProfileManager.shared.profile?.postsCount ?? 0
    }
    
    var shouldShowLoadingFooter: Bool = true
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func cellModel(for index: Int) -> ProfilePostCellModel? {
        guard index < posts.count else { return nil }
        let post = posts[index]
        
        // TODO: Display only first item for post as there is no desigh for multi-item post
        guard let item = post.contents.first else {
            return nil
        }
        return ProfilePostCellModel(id: post.id, urlString: item.previewUrl)
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
