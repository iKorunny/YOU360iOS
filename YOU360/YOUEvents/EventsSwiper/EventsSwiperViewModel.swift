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
    func reload(with models: [EventsSwiperBussiness])
    
    func runActivity()
    func stopActivity(completion: @escaping (() -> Void))
}

protocol EventsSwiperViewModel {
    var dataModels: [EventsSwiperBussiness] { get }
    
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
            self.reloadIfNeeded()
        }
        return manager
    }()
    
    private weak var view: EventsSwiperView?
    
    var dataModels: [EventsSwiperBussiness] = [] {
        didSet {
            view?.reload(with: dataModels)
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        if locationManager.status == .unknown {
            locationManager.startUpdatingLocation()
        }
        
        view?.onLocationStatusChanged(newStatus: locationManager.status)
        
        reloadIfNeeded()
    }
    
    private func reloadIfNeeded() {
        guard locationManager.status == .granted else { return }
        //TODO: request models
        
        view?.runActivity()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.view?.stopActivity {
                
            }
            self?.dataModels = [
                EventsSwiperBussiness(id: "0", events: [
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1920/1080"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1930/1090"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1921/1081"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1922/1082"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1923/1083"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1924/1084"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1925/1085")
                ]),
                EventsSwiperBussiness(id: "1", events: [
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1926/1086"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1931/1091"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1927/1087")
                ]),
                EventsSwiperBussiness(id: "2", events: [
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1920/1080"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1930/1090"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1921/1081"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1922/1082"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1925/1085")
                ]),
                EventsSwiperBussiness(id: "3", events: [
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1928/1089"),
                    EventsSwiperEvent(type: .image, urlString: "https://random.imagecdn.app/1929/1089")
                ])
            ]
        }
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
        reloadIfNeeded()
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
