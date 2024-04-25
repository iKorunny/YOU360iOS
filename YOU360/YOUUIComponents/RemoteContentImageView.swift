//
//  RemoteContentImageView.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 4/22/24.
//

import UIKit
import YOUNetworking

public protocol RemoteContentImageActivity {
    init()
    func show()
    func hide()
    func setToCenter(of view: UIView)
    func setup()
}

public final class RemoteContentImageView: UIImageView {
    
    private var loaderType: SingleImageLoading.Type = SingleImageLoader.self
    private var activityType: RemoteContentImageActivity.Type = RemoteImageViewActivityDefault.self
    
    public var placeholderImage: UIImage? {
        didSet {
            if image == nil {
                image = placeholderImage
            }
        }
    }
    
    private var loader: SingleImageLoading? {
        didSet {
            oldValue?.stopLoading()
        }
    }
    
    private lazy var activity: RemoteContentImageActivity = {
        let actView = activityType.init()
        actView.setup()
        
        actView.setToCenter(of: self)
        
        return actView
    }()
    
    public func setDependecies(loader: SingleImageLoading.Type, activity: RemoteContentImageActivity.Type) {
        loaderType = loader
        activityType = activity
    }

    public func setImage(with url: URL) {
        let newLoader = loaderType.init(with: url)
        activity.show()
        newLoader.load {
            [weak self] newData in
            DispatchQueue.main.async {
                [weak self] in
                
                if let imgData = newData, let img = UIImage(data: imgData) {
                    self?.image = img
                }
                else {
                    self?.image = self?.placeholderImage
                }
                
                self?.activity.hide()
            }
        }
        
        loader = newLoader
    }
    
    public func setImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        setImage(with: url)
    }
}

class RemoteImageViewActivityDefault: UIActivityIndicatorView, RemoteContentImageActivity {
    func show() {
        self.startAnimating()
        self.isHidden = false
    }
    
    func hide() {
        self.stopAnimating()
    }
    
    func setToCenter(of view: UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.center = view.center
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setup() {
        style = .large
    }
}
