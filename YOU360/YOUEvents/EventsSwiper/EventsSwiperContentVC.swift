//
//  EventsSwiperContentVC.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/21/24.
//

import UIKit
import YOUUtils

final class EventsSwiperContentVC: UIViewController {
    private enum Constants {
        static let lineHeight: CGFloat = 3
        static let lineTopOffset: CGFloat = 4
        
        static let contentCornerRadius: CGFloat = 20
        static let contentInsets: UIEdgeInsets = .init(top: 8, left: 20, bottom: -12, right: -20)
    }
    
    private lazy var posterVCs: [EventsSwiperPosterVC] = {
        let firstVC = EventsSwiperPosterVC()
        firstVC.view.translatesAutoresizingMaskIntoConstraints = false
        return [firstVC]
    }()
    
    private lazy var lineVC: EventsSwiperStoryLineVC = {
        let vc = EventsSwiperStoryLineVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorPallete.appWhiteSecondary
        
        lineVC.willMove(toParent: self)
        
        view.addSubview(lineVC.view)
        lineVC.view.heightAnchor.constraint(equalToConstant: Constants.lineHeight).isActive = true
        lineVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lineVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lineVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.lineTopOffset).isActive = true
        
        addChild(lineVC)
        lineVC.didMove(toParent: self)
        
        view.addSubview(contentContainer)
        contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        contentContainer.topAnchor.constraint(equalTo: lineVC.view.bottomAnchor, constant: Constants.contentInsets.top).isActive = true
        contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.contentInsets.right).isActive = true
        contentContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.contentInsets.bottom).isActive = true
        
        guard let firstPosterVC = posterVCs.first else { return }
        addChildToContentContainer(vc: firstPosterVC)
        firstPosterVC.showImage(with: URL(string: "https://random.imagecdn.app/3850/2160"))
    }
    
    func reload() {
        lineVC.redraw(with: 7)
        lineVC.set(activeIndex: 0)
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
}
