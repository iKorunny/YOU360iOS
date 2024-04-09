//
//  LoaderManager.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 2/27/24.
//

import Foundation
import UIKit

public final class LoaderManager {
    private lazy var fullScreenLoader: FullscreenLoading = {
       return FulScreenLoaderVC()
    }()
    private var fullScreenLoaderCounter = 0
    
    public init() {
        fullScreenLoaderCounter = 0
    }
    
    public func addFullscreenLoader(for vc: UIViewController) {
        if fullScreenLoaderCounter == 0 {
            fullScreenLoader.present(from: vc)
        }
        
        fullScreenLoaderCounter += 1
    }
    
    public func removeFullscreenLoader(completion: ((Bool) -> Void)? = nil) {
        fullScreenLoaderCounter -= 1
        
        guard fullScreenLoaderCounter <= 0 else { 
            completion?(false)
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.fullScreenLoader.remove {
                completion?(true)
            }
        }
    }
}
