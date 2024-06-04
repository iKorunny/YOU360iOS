//
//  EventsSwiperEstablishmentContentViewModel.swift
//  YOUEvents
//
//  Created by Ihar Karunny on 6/4/24.
//

import Foundation

protocol EventsSwiperEstablishmentContentViewModelDelegate {
    func expand(bussiness: EventsSwiperBussiness)
}

protocol EventsSwiperEstablishmentContentViewModel {
    func onOpen(bussiness: EventsSwiperBussiness)
}

final class EventsSwiperEstablishmentContentViewModelImpl:
    EventsSwiperEstablishmentContentViewModel {
    private var delegate: EventsSwiperEstablishmentContentViewModelDelegate?
    
    init(delegate: EventsSwiperEstablishmentContentViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func onOpen(bussiness: EventsSwiperBussiness) {
        delegate?.expand(bussiness: bussiness)
    }
}
