//
//  EventsTransitionManager.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 6/4/24.
//

import Foundation
import UIKit

final class EventsTransitionManager {
    static func customTransition(for fromVC: UIViewController, toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC is EstablishmentDetailVC && fromVC is EventsSwiperVC {
            return EventToEstablishmentTransition()
        }
        
        return nil
    }
}
