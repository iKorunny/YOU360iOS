//
//  EventsSwiperEstablishmentContentVC.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/25/24.
//

import UIKit
import YOUUtils

final class EventsSwiperEstablishmentContentVC: UIViewController {
    private enum Constants {
        static let lineHeight: CGFloat = 3
        static let lineTopOffset: CGFloat = 4
        
        static let contentCornerRadius: CGFloat = 20
        static let contentInsets: UIEdgeInsets = .init(top: 8, left: 20, bottom: -12, right: -20)
    }
    
    private lazy var lineVC: EventsSwiperStoryLineVC = {
        let vc = EventsSwiperStoryLineVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private lazy var posterVC: EventsSwiperPosterVC = {
        let vc = EventsSwiperPosterVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.layer.masksToBounds = true
        return vc
    }()
    
    private lazy var videoPosterVC: EventsSwiperVideoPosterVC = {
        let vc = EventsSwiperVideoPosterVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.layer.masksToBounds = true
        vc.view.isHidden = true
        return vc
    }()
    
    private lazy var contentContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.masksToBounds = true
        container.layer.cornerRadius = Constants.contentCornerRadius
        return container
    }()
    
    private var bussinessModel: EventsSwiperBussiness?
    private var posterIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupColors() {
        view.backgroundColor = ColorPallete.appWhiteSecondary
    }
    
    private func setupUI() {
        lineVC.willMove(toParent: self)
        view.addSubview(lineVC.view)
        lineVC.view.heightAnchor.constraint(equalToConstant: Constants.lineHeight).isActive = true
        lineVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lineVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lineVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.lineTopOffset).isActive = true
        addChild(lineVC)
        lineVC.didMove(toParent: self)
        
        view.addSubview(contentContainer)
        contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentContainer.topAnchor.constraint(equalTo: lineVC.view.bottomAnchor, constant: Constants.contentInsets.top).isActive = true
        contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        addChildToContentContainer(vc: posterVC)
        addChildToContentContainer(vc: videoPosterVC)
    }
    
    private func addChildToContentContainer(vc: UIViewController) {
        vc.willMove(toParent: self)
        
        contentContainer.addSubview(vc.view)
        vc.view.topAnchor.constraint(equalTo: contentContainer.topAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor).isActive = true
        
        vc.didMove(toParent: self)
    }
    
    func show(bussiness: EventsSwiperBussiness) {
        posterIndex = 0
        bussinessModel = bussiness
        lineVC.redraw(with: bussinessModel?.events.count ?? 0)
        lineVC.set(activeIndex: posterIndex)
        posterVC.reset()
        videoPosterVC.reset()
        if let event = event(by: posterIndex) {
            showPoster(for: event)
        }
    }
    
    func toNextPoster() {
        guard let bussinessModel, (bussinessModel.events.count - posterIndex) > 1 else { return }
        posterIndex += 1
        lineVC.set(activeIndex: posterIndex)
        posterVC.reset()
        videoPosterVC.reset()
        if let event = event(by: posterIndex) {
            showPoster(for: event)
        }
    }
    
    func toPreviousPoster() {
        guard posterIndex > 0 else { return }
        posterIndex -= 1
        lineVC.set(activeIndex: posterIndex)
        posterVC.reset()
        videoPosterVC.reset()
        if let event = event(by: posterIndex) {
            showPoster(for: event)
        }
    }
    
    private func showPoster(for event: EventsSwiperEvent) {
        switch event.type {
        case .image:
            videoPosterVC.view.isHidden = true
            posterVC.showImage(with: event.url)
        case .video:
            videoPosterVC.view.isHidden = false
            videoPosterVC.showVideo(with: event.url)
        }
    }
    
    private func event(by index: Int) -> EventsSwiperEvent? {
        guard let events = bussinessModel?.events, index < events.count else { return nil }
        
        return events[index]
    }
}
