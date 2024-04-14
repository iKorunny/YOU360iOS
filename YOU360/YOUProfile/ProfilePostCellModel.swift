//
//  ProfilePostCellModel.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 4/14/24.
//

import Foundation
import UIKit
import YOUNetworking

final class ProfilePostCellModel {
    weak var cell: ProfileContentCell? {
        didSet {
            if cell == nil {
                print()
            }
            cell?.set(image: image)
        }
    }
    
    private var image: UIImage?
    private var loadDataTask: URLSessionDataTask?
    
    var url: URL? {
        return URL(string: urlString)
    }
    
    let id: String
    let urlString: String
    
    func loadImageIfNeeded() {
        guard image == nil, let url else { return }
        
        loadDataTask = ContentLoaders.imageLoader.dataTaskToLoadImage(with: url) { [weak self] image in
            self?.loadDataTask = nil
            self?.image = image
            self?.cell?.set(image: image)
        }
    }
    
    init(id: String, urlString: String) {
        self.id = id
        self.urlString = urlString
    }
}
