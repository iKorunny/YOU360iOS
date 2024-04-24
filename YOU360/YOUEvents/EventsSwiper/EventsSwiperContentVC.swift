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
    
    private lazy var contentTapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(onTap))
    }()
    private lazy var contentLongPressGesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
    }()
    private lazy var contentSwipeToNextGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(onNextSwipe))
        gesture.direction = .left
        return gesture
    }()
    private lazy var contentSwipeToPreviousGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(onPreviousSwipe))
        gesture.direction = .right
        return gesture
    }()
    
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
    
    private lazy var contentGestuiresView: UIView = {
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
    
    private func setupColors() {
        view.backgroundColor = ColorPallete.appWhiteSecondary
    }
    
    private func setupUI() {
        setupColors()
        
        view.addSubview(contentGestuiresView)
        contentGestuiresView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentGestuiresView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.contentInsets.bottom).isActive = true
        contentGestuiresView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentGestuiresView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        contentGestuiresView.addSubview(contentAnimationView)
        contentAnimationView.leadingAnchor.constraint(equalTo: contentGestuiresView.leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        contentAnimationView.topAnchor.constraint(equalTo: contentGestuiresView.topAnchor).isActive = true
        contentAnimationView.trailingAnchor.constraint(equalTo: contentGestuiresView.trailingAnchor, constant: Constants.contentInsets.right).isActive = true
        contentAnimationView.bottomAnchor.constraint(equalTo: contentGestuiresView.bottomAnchor).isActive = true
        
        lineVC.willMove(toParent: self)
        contentAnimationView.addSubview(lineVC.view)
        lineVC.view.heightAnchor.constraint(equalToConstant: Constants.lineHeight).isActive = true
        lineVC.view.leadingAnchor.constraint(equalTo: contentAnimationView.leadingAnchor).isActive = true
        lineVC.view.trailingAnchor.constraint(equalTo: contentAnimationView.trailingAnchor).isActive = true
        lineVC.view.topAnchor.constraint(equalTo: contentAnimationView.topAnchor, constant: Constants.lineTopOffset).isActive = true
        addChild(lineVC)
        lineVC.didMove(toParent: self)
        
        contentAnimationView.addSubview(contentContainer)
        contentContainer.leadingAnchor.constraint(equalTo: contentAnimationView.leadingAnchor).isActive = true
        contentContainer.topAnchor.constraint(equalTo: lineVC.view.bottomAnchor, constant: Constants.contentInsets.top).isActive = true
        contentContainer.trailingAnchor.constraint(equalTo: contentAnimationView.trailingAnchor).isActive = true
        contentContainer.bottomAnchor.constraint(equalTo: contentAnimationView.bottomAnchor).isActive = true
        
        guard let firstPosterVC = posterVCs.first else { return }
        addChildToContentContainer(vc: firstPosterVC)
        firstPosterVC.showImage(with: URL(string: "https://random.imagecdn.app/3850/2160"))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.cubicAnimator.animate(with: .fromLeft, currentVC: firstPosterVC) {
                self.addChildToContentContainer(vc: self.newPosterVC)
            }
            
            self.newPosterVC.showImage(with: URL(string: "https://random.imagecdn.app/1920/1080"))
        }
        
        
        contentGestuiresView.addGestureRecognizer(contentTapGesture)
        contentGestuiresView.addGestureRecognizer(contentLongPressGesture)
        contentGestuiresView.addGestureRecognizer(contentSwipeToNextGesture)
        contentGestuiresView.addGestureRecognizer(contentSwipeToPreviousGesture)
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        guard let touchView = sender.view else { return }
        let touchLocation = sender.location(in: touchView)
        let leftSideTouch: Bool = touchLocation.x < touchView.bounds.width * 0.5
        if leftSideTouch {
            print("Touched left!!!!")
        }
        else {
            print("Touched right!!!!")
        }
    }
    
    @objc private func onLongPress(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            print("Long press start!!!!")
        case .ended:
            print("Long press end!!!!")
        default: break
        }
    }
    
    @objc private func onNextSwipe(sender: UISwipeGestureRecognizer) {
        print("Swipe Next!!!!")
    }
    
    @objc private func onPreviousSwipe(sender: UISwipeGestureRecognizer) {
        print("Swipe Previous!!!!")
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
