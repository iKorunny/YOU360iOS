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
    
    private lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("BOTTOM BUTTON", for: .normal)
        button.backgroundColor = UIColor.magenta
        button.addTarget(self, action: #selector(bottomAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var middleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("MIDDLE BUTTON", for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(middleAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        view.addSubview(middleButton)
        middleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        middleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(bottomButton)
        bottomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupColors() {
        view.backgroundColor = ColorPallete.appWhiteSecondary
    }
    
    private func setupUI() {
        setupColors()
        
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func showImage(with url: URL?) {
        guard let url = url else { return }
        imageView.setImage(with: url)
    }
    
    @objc private func bottomAction() {
        print("BOTTOM BUTTON")
    }
    
    @objc private func middleAction() {
        print("MIDDLE BUTTON")
    }
}
