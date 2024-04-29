//
//  EventsSwiperPosterVC.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/22/24.
//

import UIKit
import YOUUIComponents
import YOUUtils

final class EventsSwiperPosterVC: UIViewController {
    
    private lazy var imageView: RemoteContentImageView = {
        let imageContentView = RemoteContentImageView()
        imageContentView.translatesAutoresizingMaskIntoConstraints = false
        imageContentView.contentMode = .scaleAspectFill
        imageContentView.isUserInteractionEnabled = false
        return imageContentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupColors() {
        view.backgroundColor = ColorPallete.appGrey2
    }
    
    private func setupUI() {
        setupColors()
        
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func reset() {
        imageView.image = nil
    }
    
    func showImage(with url: URL?) {
        guard let url = url else { return }
        imageView.setImage(with: url)
    }
}
