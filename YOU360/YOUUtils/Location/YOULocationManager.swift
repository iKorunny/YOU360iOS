//
//  YOULocationManager.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/20/24.
//

import Foundation
import CoreLocation

public struct YOULocationManagerCoordinate {
    public let latitude: CGFloat
    public let longitude: CGFloat
}

public enum YOULocationManagerAccessStatus {
    case unknown
    case granted
    case denied
}

public final class YOULocationManager: NSObject {
    private static var sharedManager: YOULocationManager?
    public static func shared() -> YOULocationManager {
        guard let existingManager = sharedManager else {
            let newManager = YOULocationManager()
            sharedManager = newManager
            return newManager
        }
        
        return existingManager
    }
    
    private let locationManager: CLLocationManager
    public var status: YOULocationManagerAccessStatus {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return .unknown
        case .denied, .restricted:
            return .denied
        case .authorizedAlways, .authorizedWhenInUse:
            return .granted
        @unknown default:
            return .unknown
        }
    }
    
    private var statusObservers: [ClosureObserver] = []
    
    public var location: YOULocationManagerCoordinate? {
        guard let userLocation = locationManager.location else { return nil }
        return YOULocationManagerCoordinate(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    }
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        super.init()
        
        locationManager.delegate = self
    }
    
    public func startUpdatingLocation() {
        if status == .unknown {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.stopUpdatingLocation()
    }
    
    public func observeStatus(callback: @escaping (() -> Void)) -> AnyObject? {
        let observer = ClosureObserver(closure: callback)
        statusObservers.append(observer)
        return observer
    }
    
    public func removeStatus(observer: AnyObject?) {
        guard let observer = observer else { return }
        statusObservers.removeAll(where: { $0 === observer })
    }
}

extension YOULocationManager: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            self?.statusObservers.forEach { $0.closure() }
        }
    }
}
