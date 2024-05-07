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
        removeObservers()
    }
    
    private var statusObserver: NSKeyValueObservation?
    private var rateObserver: NSKeyValueObservation?
    
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
    
    private func removeObservers() {
        statusObserver?.invalidate()
        statusObserver = nil
        rateObserver?.invalidate()
        rateObserver = nil
    }
    
    public func reset() {
        DownloadCaches.getContentCache().removeAllCachedResponses()
        playerController.player?.pause()
        removeObservers()
        playerController.player?.replaceCurrentItem(with: nil)
        playerLooper = nil
        activityControl.hide()
    }
    
    public func playVideo(with url: URL?) {
        guard let url = url else { return }
        playerController.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
        
        statusObserver = playerController.player?.currentItem?.observe(\AVPlayerItem.status, changeHandler: { [weak self] item, _ in
            DispatchQueue.main.async { [weak self] in
                switch item.status {
                case .readyToPlay:
                    self?.activityControl.hide()
                case .failed:
                    self?.activityControl.hide()
                case .unknown:
                    self?.activityControl.show()
                @unknown default:
                    self?.activityControl.hide()
                }
            }
        })
        
        rateObserver = playerController.player?.observe(\AVPlayer.rate, changeHandler: { [weak self] player, _ in
            DispatchQueue.main.async { [weak self] in
                switch player.status {
                case .readyToPlay:
                    player.rate.isZero ? self?.activityControl.show() : self?.activityControl.hide()
                case .unknown:
                    self?.activityControl.show()
                case .failed:
                    self?.activityControl.hide()
                @unknown default:
                    self?.activityControl.hide()
                }
            }
        })
        
        if let player = playerController.player as? AVQueuePlayer, let playerItem = player.currentItem {
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        }
        playerController.player?.play()
        guard playerController.player?.currentItem != nil else { return }
        activityControl.show()
    }
}
