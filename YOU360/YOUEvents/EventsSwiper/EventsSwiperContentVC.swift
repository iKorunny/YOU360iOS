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
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        gesture.delegate = self
        return gesture
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
        let animator = CubicAnimator<UIViewController>(animationOnView: contentAnimationView) { [weak self] hiddenVC in
            guard let vc = hiddenVC else { return }
            self?.removeChildFromContentContainer(vc: vc)
        }
        return animator
    }()
    
    var dataSource: EventsSwiperContentVCDataSource?
    private lazy var contentControllers: Queue<EventsSwiperEstablishmentContentVC> = {
        let queue = Queue<EventsSwiperEstablishmentContentVC>.init(item: .init())
        queue.addToRear(item: .init())
        queue.addToRear(item: .init())
        queue.loop()
        return queue
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
        
        contentGestuiresView.addGestureRecognizer(contentTapGesture)
        contentGestuiresView.addGestureRecognizer(contentLongPressGesture)
        contentGestuiresView.addGestureRecognizer(contentSwipeToNextGesture)
        contentGestuiresView.addGestureRecognizer(contentSwipeToPreviousGesture)
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        guard let touchView = sender.view,
        let dataSource = dataSource else { return }
        let touchLocation = sender.location(in: touchView)
        let leftSideTouch: Bool = touchLocation.x < touchView.bounds.width * 0.5
        if leftSideTouch {
            if dataSource.isFirstEvent {
                toPreviousBussinessIfPossible()
            }
            else {
                toPreviousEventIfPossible()
            }
        }
        else {
            if dataSource.isLastEvent {
                toNextBussinessIfPossible()
            }
            else {
                toNextEventIfPossible()
            }
        }
    }
    
    private func toNextEventIfPossible() {
        guard let dataSource = dataSource,
              !dataSource.isLastEvent else { return }
        let currentVC = contentControllers.currentItem
        currentVC?.toNextPoster()
        dataSource.onNextEvent()
    }
    
    private func toPreviousEventIfPossible() {
        guard let dataSource = dataSource,
              !dataSource.isFirstEvent else { return }
        let currentVC = contentControllers.currentItem
        currentVC?.toPreviousPoster()
        dataSource.onPreviousEvent()
    }
    
    @objc private func onLongPress(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            contentControllers.currentItem?.setOverlays(hidden: true)
        case .ended:
            contentControllers.currentItem?.setOverlays(hidden: false)
        default: break
        }
    }
    
    @objc private func onNextSwipe(sender: UISwipeGestureRecognizer) {
        toNextBussinessIfPossible()
    }
    
    private func toNextBussinessIfPossible() {
        guard let dataSource = dataSource,
              !dataSource.isLastBussiness,
              let nextBussiness = dataSource.nextBussiness else { return }
        let currentVC = contentControllers.currentItem
        guard let nextVC = contentControllers.next() else { return }
        nextVC.show(bussiness: nextBussiness)
        cubicAnimator.animate(with: .fromRight, currentItem: currentVC) { [weak self] in
            self?.addContent(vc: nextVC)
        }
    }
    
    @objc private func onPreviousSwipe(sender: UISwipeGestureRecognizer) {
        toPreviousBussinessIfPossible()
    }
    
    private func toPreviousBussinessIfPossible() {
        guard let dataSource = dataSource,
              !dataSource.isFirstBussiness,
              let previousBussiness = dataSource.previousBussiness else { return }
        let currentVC = contentControllers.currentItem
        guard let previousVC = contentControllers.previous() else { return }
        previousVC.show(bussiness: previousBussiness)
        cubicAnimator.animate(with: .fromLeft, currentItem: currentVC) { [weak self] in
            self?.addContent(vc: previousVC)
        }
    }
    
    private func addContent(vc: UIViewController) {
        vc.willMove(toParent: self)
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        contentAnimationView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        vc.view.topAnchor.constraint(equalTo: contentAnimationView.topAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: contentAnimationView.leadingAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: contentAnimationView.bottomAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: contentAnimationView.trailingAnchor).isActive = true
    }
    
    private func removeChildFromContentContainer(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        vc.didMove(toParent: nil)
    }
    
    func clean() {
        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
            $0.didMove(toParent: nil)
        }
    }
    
    func reload() {
        contentControllers.forEach { [weak self] controller in
            guard controller.parent === self else { return }
            self?.removeChildFromContentContainer(vc: controller)
        }
        
        if let currentContentVC = contentControllers.currentItem,
            let bussiness = dataSource?.bussiness {
            addContent(vc: currentContentVC)
            currentContentVC.show(bussiness: bussiness)
        }
    }
}

extension EventsSwiperContentVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchedView = gestureRecognizer.view
        
        switch touchedView {
        case is UIButton : return false
        default: return true
        }
    }
}
