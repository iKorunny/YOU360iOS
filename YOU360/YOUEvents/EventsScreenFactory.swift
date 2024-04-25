//
//  EventsScreenFactory.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 4/20/24.
//

import Foundation
import UIKit
import YOUUIComponents

public final class EventsScreenFactory {
    public static func createHomeRootVC() -> UIViewController {
        return YOUNavigationController(rootViewController: EventsSwiperVC(viewModel: EventsSwiperViewModelImpl()), type: .home)
    }
}
