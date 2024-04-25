//
//  FullScreenLoopedVideoPlayerController.swift
//  YOUUIComponents
//
//  Created by Ihar Karunny on 4/26/24.
//

import UIKit
import AVKit
import AVFoundation
import YOUUtils
import YOUNetworking

public final class FullScreenLoopedVideoPlayerController: UIViewController {
    private enum Constants {
        static let playerStatusObserveKey: String = "status"
        static let playerRateObserveKey: String = "rate"
    }
    
    deinit {
        playerController.player?.pause()
        NotificationCenter.default.removeObserver(self)
        guard observingPlayer else { return }
        playerController.player?.currentItem?.removeObserver(self, forKeyPath: Constants.playerRateObserveKey)
        observingPlayer = false
    }
    
    private var observingPlayer = false
    
    private lazy var activityControl: RemoteImageViewActivityDefault = {
        let activity = RemoteImageViewActivityDefault(style: .large)
        activity.setup()
        activity.setToCenter(of: view)
        activity.isHidden = true
        return activity
    }()
    
    private var playerLooper: AVPlayerLooper?
    
    private lazy var playerController: AVPlayerViewController = {
        let controller = AVPlayerViewController()
        let player = AVQueuePlayer()
        controller.player = player
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.isUserInteractionEnabled = false
        controller.view.backgroundColor = .clear
        return controller
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerStuck), name: AVPlayerItem.playbackStalledNotification, object: playerController.player)
    }
    
    @objc private func playerStuck(notification: Notification) {
        guard let player = notification.object as? AVPlayer, player === playerController.player else { return }
        DispatchQueue.main.async { [weak self] in
            self?.activityControl.show()
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let playerItem = object as? AVPlayerItem, 
            keyPath == Constants.playerStatusObserveKey {
            switch playerItem.status {
            case .readyToPlay:
                activityControl.hide()
            case .failed:
                activityControl.hide()
            case .unknown:
                activityControl.show()
            @unknown default:
                activityControl.hide()
            }
        }
        
        if keyPath == Constants.playerRateObserveKey,
            let player = playerController.player {
            player.rate.isZero ? activityControl.show() : activityControl.hide()
        }
    }
    
    private func setupColors() {
        view.backgroundColor = .clear
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
    
    public func reset() {
        DownloadCaches.getContentCache().removeAllCachedResponses()
        playerController.player?.pause()
        if observingPlayer {
            playerController.player?.currentItem?.removeObserver(self, forKeyPath: Constants.playerStatusObserveKey)
            playerController.player?.currentItem?.removeObserver(self, forKeyPath: Constants.playerRateObserveKey)
            observingPlayer = false
        }
        playerController.player?.replaceCurrentItem(with: nil)
        playerLooper = nil
        activityControl.hide()
    }
    
    public func playVideo(with url: URL?) {
        guard let url = url else { return }
        playerController.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
        playerController.player?.currentItem?.addObserver(self, forKeyPath: Constants.playerStatusObserveKey, options: .new, context: nil)
        playerController.player?.currentItem?.addObserver(self, forKeyPath: Constants.playerRateObserveKey, options: .new, context: nil)
        observingPlayer = true
        if let player = playerController.player as? AVQueuePlayer, let playerItem = player.currentItem {
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        }
        playerController.player?.play()
        guard playerController.player?.currentItem != nil else { return }
        activityControl.show()
    }
}
