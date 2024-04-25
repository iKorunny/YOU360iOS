//
//  EventsSwiperViewModel.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/25/24.
//

import Foundation
import YOUUtils
import UIKit

protocol EventsSwiperView: AnyObject {
    func onLocationStatusChanged(newStatus: YOULocationManagerAccessStatus)
}

protocol EventsSwiperViewModel {
    func set(view: EventsSwiperView)
    
    func onViewDidLoad()
    
    func onViewWillAppear()
    
    func onToSettings()
    
    func onToMenu()
    
    func onToSearch()
}

final class EventsSwiperViewModelImpl {
    deinit {
        NotificationCenter.default.removeObserver(self)
        locationManager.removeStatus(observer: statusObserver)
    }
    
    private var statusObserver: AnyObject?
    
    private lazy var locationManager: YOULocationManager = {
        let manager = YOULocationManager.shared()
        statusObserver = manager.observeStatus { [weak self] in
            guard let self = self else { return }
            self.view?.onLocationStatusChanged(newStatus: self.locationManager.status)
        }
        return manager
    }()
    
    private weak var view: EventsSwiperView?
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        if locationManager.status == .unknown {
            locationManager.startUpdatingLocation()
        }
        
        view?.onLocationStatusChanged(newStatus: locationManager.status)
    }
}

extension EventsSwiperViewModelImpl: EventsSwiperViewModel {
    func set(view: EventsSwiperView) {
        self.view = view
    }
    
    func onViewDidLoad() {
        locationManager.startUpdatingLocation()
        setupNotifications()
    }
    
    func onViewWillAppear() {
        view?.onLocationStatusChanged(newStatus: locationManager.status)
    }
    
    func onToSettings() {
        AppRedirector.toSettings()
    }
    
    func onToMenu() {
        print("EventsSwiperVC -> toMenu()")
    }
    
    func onToSearch() {
        print("EventsSwiperVC -> toSearch()")
    }
}
