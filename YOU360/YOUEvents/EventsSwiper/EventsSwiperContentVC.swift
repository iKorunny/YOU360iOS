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
        firstVC.view.layer.masksToBounds = true
        return [firstVC]
    }()
    
    private lazy var newPosterVC: EventsSwiperPosterVC = {
        let vc = EventsSwiperPosterVC()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.layer.masksToBounds = true
        return vc
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
    
    private lazy var contentAnimationView: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var cubicAnimator: CubicAnimator = {
        let animator = CubicAnimator(animationOnView: contentAnimationView) { [weak self] hiddenVC in
            guard let vc = hiddenVC else { return }
            self?.removeChildFromContentContainer(vc: vc)
        }
        return animator
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
        
        view.addSubview(contentAnimationView)
        contentAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentAnimationView.topAnchor.constraint(equalTo: lineVC.view.bottomAnchor, constant: Constants.contentInsets.top).isActive = true
        contentAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentAnimationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.contentInsets.bottom).isActive = true
        
        contentAnimationView.addSubview(contentContainer)
        contentContainer.leadingAnchor.constraint(equalTo: contentAnimationView.leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        contentContainer.topAnchor.constraint(equalTo: contentAnimationView.topAnchor).isActive = true
        contentContainer.trailingAnchor.constraint(equalTo: contentAnimationView.trailingAnchor, constant: Constants.contentInsets.right).isActive = true
        contentContainer.bottomAnchor.constraint(equalTo: contentAnimationView.bottomAnchor).isActive = true
        
        guard let firstPosterVC = posterVCs.first else { return }
        addChildToContentContainer(vc: firstPosterVC)
        firstPosterVC.showImage(with: URL(string: "https://random.imagecdn.app/3850/2160"))
        
        //TODO: remove debug code
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.cubicAnimator.animate(with: .fromLeft, currentVC: firstPosterVC) {
                self.addChildToContentContainer(vc: self.newPosterVC)
            }
            
            self.newPosterVC.showImage(with: URL(string: "https://random.imagecdn.app/1920/1080"))
        }
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
    
    private func removeChildFromContentContainer(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        vc.didMove(toParent: nil)
    }
}
