//
//  EventsSwiperContentViewModel.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 6/4/24.
//

import Foundation

protocol EventsSwiperContentViewModelDelegate {
    func expand(bussiness: EventsSwiperBussiness)
}

protocol EventsSwiperContentViewModel {
    func onExpand(bussiness: EventsSwiperBussiness)
}

final class EventsSwiperContentViewModelImpl: EventsSwiperContentViewModel {
    private var delegate: EventsSwiperContentViewModelDelegate?
    
    init(delegate: EventsSwiperContentViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func onExpand(bussiness: EventsSwiperBussiness) {
        delegate?.expand(bussiness: bussiness)
    }
}
