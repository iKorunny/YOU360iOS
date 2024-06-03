//
//  EventToEstablishmentTransition.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 6/3/24.
//

import Foundation
import UIKit
import YOUUtils

protocol EventToEstablishmentFromTransition {
    func animatingView() -> UIView?
}

final class EventToEstablishmentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private enum Constants {
        static let duration: TimeInterval = 0.3
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? (EventsSwiperVC & EventToEstablishmentFromTransition),
            let toViewController = transitionContext.viewController(forKey: .to) as? EstablishmentDetailVC,
            let animatingView = fromViewController.animatingView() else { return }
        
        let containerView = transitionContext.containerView
        
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = ColorPallete.appWhiteSecondary
        snapshotContentView.frame = fromViewController.view.bounds
        
        let snapshotImage = animatingView.asImage()
        let snapshotInfoView = UIImageView(image: snapshotImage)
        snapshotInfoView.frame = containerView.convert(animatingView.frame, from: animatingView.superview)
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(snapshotInfoView)
        
        toViewController.view.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: Constants.duration, curve: .easeInOut) {
            snapshotInfoView.frame.origin.y = 42 + 222 / 375 * fromViewController.view.bounds.width
            snapshotInfoView.alpha = 0
            toViewController.view.alpha = 1
        }
        
        animator.addCompletion { position in
            snapshotContentView.removeFromSuperview()
            snapshotInfoView.removeFromSuperview()
            
            
            transitionContext.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
}
