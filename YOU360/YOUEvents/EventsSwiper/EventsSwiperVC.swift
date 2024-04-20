//
//  EventsSwiperVC.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/20/24.
//

import UIKit
import YOUUtils

final class EventsSwiperVC: UIViewController {
    
    private var statusObserver: AnyObject?
    
    private lazy var locationManager: YOULocationManager = {
        let manager = YOULocationManager.shared()
        statusObserver = manager.observeStatus { [weak self] in
            self?.gpsAccessUpdated()
        }
        return manager
    }()
    
    private lazy var waitingAccessToGPSView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        let imageView = UIImageView(image: .init(named: "LOGOYOU360"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        contentView.isHidden = true
        return contentView
    }()
    
    private lazy var accessToGPSDeniedView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        
        let button = UIButton()
        button.setTitle("LocationAccessDeniedToSettingsButtonTitle".localised(), for: .normal)
        button.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.isHidden = true
        return contentView
    }()
    
    private lazy var accessToGPSGrantedView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = ColorPallete.appWhiteSecondary
        
        contentView.isHidden = true
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotifications()
        
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gpsAccessUpdated()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = ColorPallete.appWhiteSecondary
        
        view.addSubview(waitingAccessToGPSView)
        waitingAccessToGPSView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        waitingAccessToGPSView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        waitingAccessToGPSView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        waitingAccessToGPSView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(accessToGPSDeniedView)
        accessToGPSDeniedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        accessToGPSDeniedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        accessToGPSDeniedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        accessToGPSDeniedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(accessToGPSGrantedView)
        accessToGPSGrantedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        accessToGPSGrantedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        accessToGPSGrantedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        accessToGPSGrantedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func appDidBecomeActive() {
        if locationManager.status == .unknown {
            locationManager.startUpdatingLocation()
        }
        
        gpsAccessUpdated()
    }
    
    private func gpsAccessUpdated() {
        switch locationManager.status {
        case .unknown:
            waitingAccessToGPSView.isHidden = false
            accessToGPSDeniedView.isHidden = true
            accessToGPSGrantedView.isHidden = true
        case .granted:
            waitingAccessToGPSView.isHidden = true
            accessToGPSDeniedView.isHidden = true
            accessToGPSGrantedView.isHidden = false
        case .denied:
            waitingAccessToGPSView.isHidden = true
            accessToGPSDeniedView.isHidden = false
            accessToGPSGrantedView.isHidden = true
        }
    }
    
    @objc private func goToSettings() {
        AppRedirector.toSettings()
    }
}
