//
//  EventsSwiperViewModel.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/25/24.
//

import Foundation
import YOUUtils
import UIKit
import YOUNetworking
import YOUUIComponents

import YOUAuthorization
import YOUProfile

private enum Constants {
    static let pageSize: Int = 10
}

protocol EventsSwiperView: AnyObject {
    func onLocationStatusChanged(newStatus: YOULocationManagerAccessStatus)
    func reload(with models: [EventsSwiperBussiness])
    func append(models: [EventsSwiperBussiness])
    
    func runActivity()
    func stopActivity(completion: @escaping (() -> Void))
    func show(vc: UIViewController)
}

protocol EventsSwiperViewModel {
    var dataModels: [EventsSwiperBussiness] { get }
    
    func set(view: UIViewController & EventsSwiperView)
    
    func onViewDidLoad()
    
    func onViewWillAppear()
    
    func onToSettings()
    
    func onToMenu()
    
    func onToSearch()
}

final class EventsSwiperViewModelImpl: PageLoaderDelegate {
    typealias T = EstablishmentWithEvents
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        locationManager.removeStatus(observer: statusObserver)
    }
    
    private var statusObserver: AnyObject?
    
    private lazy var networkService: EventsNetworkService = {
        let service = EventsNetworkService.makeService()
        service.dataSource = self
        return service
    }()
    
    private lazy var pageLoader: SilentPageLoader = {
        return SilentPageLoader(pageSize: Constants.pageSize, dataSource: networkService, delegate: self)
    }()
    
    private lazy var locationManager: YOULocationManager = {
        let manager = YOULocationManager.shared()
        statusObserver = manager.observeStatus { [weak self] in
            guard let self = self else { return }
            self.view?.onLocationStatusChanged(newStatus: self.locationManager.status)
            self.reloadIfNeeded()
        }
        return manager
    }()
    
    private weak var view: (UIViewController & EventsSwiperView)?
    
    var dataModels: [EventsSwiperBussiness] = [] {
        didSet {
            view?.reload(with: dataModels)
        }
    }
    
    private var loadedData: [T] = []
    private var reloadInProgress = false
    
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
    
    func didLoadPage(offset: Int, with items: [T]) {
        let shouldReloadView = offset == 0
        loadedData.append(contentsOf: items)
        if shouldReloadView {
            view?.reload(with: convertLoadedEstablishmentsToUI(loaded: items))
        }
        else {
            view?.append(models: convertLoadedEstablishmentsToUI(loaded: items))
        }
    }
    
    private func convertLoadedEstablishmentsToUI(loaded: [T]) -> [EventsSwiperBussiness] {
        var result: [EventsSwiperBussiness] = []
        for item in loaded {
            let convertedEvents:[EventsSwiperEvent] = item.events.compactMap { [weak self] event in
                self?.convertLoadedEventToUI(event)
            }
            let bussinessUIModel = EventsSwiperBussiness(id: item.id,
                                                         events: convertedEvents,
                                                         likes: 5000,
                                                         name: item.name ?? "",
                                                         address: item.address?.stringValue,
                                                         category: item.categoryString)
//            if !bussinessUIModel.events.isEmpty {
                result.append(bussinessUIModel)
//            }
        }
        
        return result
    }
    
    private func convertLoadedEventToUI(_ event: Event) -> EventsSwiperEvent? {
        //TODO: remove comments and add logic
        guard /*let afisha = event.banner,*/
              let priceCode = event.ticketPrice?.keys.first,
              let priceAmount = event.ticketPrice?[priceCode],
              let eventDateString = event.startDate,
              let eventDate = Formatters.dateFromISO8601String(eventDateString)
        else { return nil }
        return EventsSwiperEvent(type: /*EventsSwiperEventType.convert(string: afisha.contentTypeFull)*/ .image,
                                 urlString: /*afisha.contentUrl*/"https://0214.by/data/event/204da255aea2cd4a75ace6018fad6b4d.jpg",
                                 price: Formatters.formatEventPrice(amount: priceAmount, currencyCode: priceCode) ?? "",
                                 date: eventDate)
    }
    
    private func reloadIfNeeded() {
        guard !reloadInProgress,
              locationManager.status == .granted else { return }
        reloadInProgress = true
        
        view?.runActivity()
        pageLoader.restartRequest { [weak self] success, page, localError in
            guard success, let page = page else {
                self?.view?.stopActivity { [weak self] in
                    if let view = self?.view {
                        if localError == .noInternet {
                            AlertsPresenter.presentNoInternet(from: view)
                        }
                        else {
                            AlertsPresenter.presentSomethingWentWrongAlert(from: view)
                        }
                    }
                }
                return
            }
            
            self?.view?.stopActivity {  }
            self?.loadedData = []
            self?.didLoadPage(offset: page.offset, with: page.items)
            self?.reloadInProgress = false
        }
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
        ////            self?.view?.stopActivity {
        ////
        ////            }
        //            self?.dataModels = [
        //                EventsSwiperBussiness(id: "0", events: [
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1920/1080",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1930/1090",
        //                                      price: "20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1921/1081",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1922/1082",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1923/1083",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1924/1084",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1925/1085",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .video,
        //                                      urlString: "https://media.istockphoto.com/id/1323816323/video/machine-counter-automatic-calculates-a-large-amount-of-dollar-banknotes-in-4k-slow-motion.mp4?s=mp4-640x640-is&k=20&c=60RyfRaPLQw8onsqGfsPvjBi9yPXJZA4b_gV6tbD6uQ=",
        //                                      price: "20.20€",
        //                                      date: Date())
        //                ],
        //                                      likes: 5000,
        //                                      name: "DRUNGLY",
        //                                      address: "1000 Route Nationale , Pusignan, France",
        //                                      category: "Night club"),
        //                EventsSwiperBussiness(id: "1", events: [
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1926/1086",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1931/1091",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1927/1087",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .video,
        //                                      urlString: "https://v3.cdnpk.net/videvo_files/video/free/2012-09/large_preview/hd1708.mp4",
        //                                      price: "20.20€",
        //                                      date: Date())
        //                ],
        //                                      likes: 5100,
        //                                      name: "DRUNGLY 2",
        //                                      address: nil,
        //                                      category: nil),
        //                EventsSwiperBussiness(id: "2", events: [
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1920/1080",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1930/1090",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1921/1081",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1922/1082",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1925/1085",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .video,
        //                                      urlString: "https://videocdn.cdnpk.net/cdn/content/video/partners0316/large_watermarked/h7975e5ac_MotionFlow6307_preview.mp4",
        //                                      price: "20.20€",
        //                                      date: Date())
        //                ],
        //                                      likes: 5200000,
        //                                      name: "DRUNGLY 3",
        //                                      address: "1000 Route Nationale , Pusignan, France",
        //                                      category: "Night club"),
        //                EventsSwiperBussiness(id: "3", events: [
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1928/1089",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .image,
        //                                      urlString: "https://random.imagecdn.app/1929/1089",
        //                                      price: "20.20€",
        //                                      date: Date()),
        //                    EventsSwiperEvent(type: .video,
        //                                      urlString: "https://v3.cdnpk.net/videvo_files/video/free/2012-09/large_preview/hd0628.mp4",
        //                                      price: "20.20€",
        //                                      date: Date())
        //                ],
        //                                      likes: 5000,
        //                                      name: "DRUNGLY 4",
        //                                      address: "1000 Route Nationale , Pusignan, France",
        //                                      category: "Night club")
        //            ]
        //        }
    }
}

extension EventsSwiperViewModelImpl: EventsSwiperViewModel {
    func set(view: UIViewController & EventsSwiperView) {
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
        
        guard let profile = ProfileManager.shared.profile else { return }
        view?.show(vc: ProfileScreenFactory.createProfileVC(for: profile))
    }
    
    func onToSearch() {
        print("EventsSwiperVC -> toSearch()")
    }
}


extension EventsSwiperViewModelImpl: EventsSwiperContentViewModelDelegate {
    func expand(bussiness: EventsSwiperBussiness) {
        let nextVc = EstablishmentDetailVC(model: EstablishmentDetailVCViewModel.init())
        self.view?.show(vc: nextVc)
    }
}

extension EventsSwiperViewModelImpl: EventsNetworkServiceDataSource {
    var location: YOULocationManagerCoordinate? {
        guard locationManager.status == .granted, 
                let location = locationManager.location else { return nil }
        return location
    }
    
    var maxDistance: Double? {
        return 40 //TODO: replace with profile settings
    }
}
