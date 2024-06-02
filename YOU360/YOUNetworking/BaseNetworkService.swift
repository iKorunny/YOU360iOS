//
//  BaseNetworkService.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 6/2/24.
//

import Foundation

public class BaseSecretPartNetworkService: BaseNetworkService {
    var secretNetworkService: SecretPartNetworkService {
        YOUNetworkingServices.secretNetworkService
    }
}

public class BaseNetworkService {
    var requestMaker: NetworkRequestMaker {
        YOUNetworkingServices.requestMaker
    }
}
