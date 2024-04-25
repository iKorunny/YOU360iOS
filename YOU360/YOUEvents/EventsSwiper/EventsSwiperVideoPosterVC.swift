//
//  EventsSwiperVideoPosterVC.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/26/24.
//

import UIKit
import YOUUtils
import YOUUIComponents

final class EventsSwiperVideoPosterVC: UIViewController {
    
    private lazy var playerController: FullScreenLoopedVideoPlayerController = {
        let controller = FullScreenLoopedVideoPlayerController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.isUserInteractionEnabled = false
        controller.view.backgroundColor = .clear
        return controller
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
        
        playerController.willMove(toParent: self)
        view.addSubview(playerController.view)
        addChild(playerController)
        playerController.didMove(toParent: self)
        
        playerController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func reset() {
        playerController.reset()
    }
    
    func showVideo(with url: URL?) {
        playerController.playVideo(with: url)
    }
}
