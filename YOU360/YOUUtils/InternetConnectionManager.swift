//
//  InternetConnectionManager.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 4/18/24.
//

import Foundation
import Network


public extension Notification.Name {
    static let InternetConnectionStatusChanged = Notification.Name("InternetConnectionStatusChanged")
}

public final class InternetConnectionManager {
    public static let shared = InternetConnectionManager()

    private lazy var networkMonitor: NWPathMonitor = {
        let networkMonitor: NWPathMonitor
        if #available(iOS 14.0, *) {
            networkMonitor = NWPathMonitor(prohibitedInterfaceTypes: [.loopback, .wiredEthernet])
        } else {
            networkMonitor = NWPathMonitor()
        }
        return networkMonitor
    }()
    
    init() {
        networkMonitor.start(queue: DispatchQueue.main)
        networkMonitor.pathUpdateHandler = { [unowned self] path in
            self.internetAvailable = (path.status == .satisfied)
        }
    }

    private var internetAvailable = true {
        didSet {
            if oldValue != internetAvailable {
                NotificationCenter.default.post(name: .InternetConnectionStatusChanged, object: nil)
            }
        }
    }

    public func handleError(error: Error?) {
        if let error = error as NSError? {
            if URLError.Code(rawValue: error.code) == .notConnectedToInternet {
                internetAvailable = false
                return
            }
        }
        internetAvailable = true
    }


    @discardableResult public func isInternetAvailable() -> Bool {
        return internetAvailable
    }
}
