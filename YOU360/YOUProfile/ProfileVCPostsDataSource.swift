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

protocol PostsDataSource {
    var postsNumber: Int { get }
    func getPost(index: Int) -> PostItem?
    func getAllPosts(completion: (_ items: [PostItem]) -> Void)
}

enum ContentType {
    case image
    case video
}

class PostItem {
    
    internal init(id: String, contentUrl: URL, previewUrl: URL, contentTypeFull: ContentType, contentTypeCompressed: ContentType, contentName: String, previewName: String) {
        self.id = id
        self.contentUrl = contentUrl
        self.previewUrl = previewUrl
        self.contentTypeFull = contentTypeFull
        self.contentTypeCompressed = contentTypeCompressed
        self.contentName = contentName
        self.previewName = previewName
    }
    
    public var id: String
    public var contentUrl: URL
    public var previewUrl: URL
    public var contentTypeFull: ContentType
    public var contentTypeCompressed: ContentType
    public var contentName: String
    public var previewName: String
}


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
    
    func mapPostContentType(typeString: String) -> ContentType? {
        switch typeString {
        case "image/jpeg":
            return .image
        default:
            return nil
        }
    }
    
    func mapPostItem(apiItem: ProfileContentItem) -> PostItem? {
        guard
            let contentUrl = URL(string: apiItem.contentUrl),
            let previewUrl = URL(string: apiItem.previewUrl),
            let contentType = mapPostContentType(typeString: apiItem.contentTypeFull),
            let previewType = mapPostContentType(typeString: apiItem.contentTypeCompressed)
        else { return nil }
        
        return PostItem(
            id: apiItem.id,
            contentUrl: contentUrl,
            previewUrl: previewUrl,
            contentTypeFull: contentType,
            contentTypeCompressed: previewType,
            contentName: apiItem.contentName,
            previewName: apiItem.previewName
        )
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

extension ProfileVCPostsDataSource: PostsDataSource {
    
    var postsNumber: Int {
        return posts.count
    }
    
    func getPost(index: Int) -> PostItem? {
        let post = posts[index].contents.first.flatMap {
            mapPostItem(apiItem: $0)
        }
        return post
    }
    
    func getAllPosts(completion: ([PostItem]) -> Void) {
        let postItems = posts.compactMap {
            $0.contents.first.flatMap({ apiItem in
                mapPostItem(apiItem: apiItem)
            })
        }
        completion(postItems)
    }
}
