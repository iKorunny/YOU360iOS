//
//  ProfileNetworkService.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 4/5/24.
//

import Foundation
import YOUNetworking

final class ProfileNetworkService {
    private var requestMaker: NetworkRequestMaker {
        YOUNetworkingServices.requestMaker
    }
    
    private var secretNetworkService: SecretPartNetworkService {
        YOUNetworkingServices.secretNetworkService
    }
    
    func makeSecretPageRequest() {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Auth/GetSecretPage")
        
        let request = requestMaker.makeAuthorizedRequest(with: url,
                                                         headerAcceptValue: "application/json",
                                                         headerContentTypeValue: "application/json",
                                                         token: secretNetworkService.authToken,
                                                         method: .get,
                                                         json: nil)
        
        secretNetworkService.performDataTask(request: request) { data, response, error, localError in
            print()
        }
    }
}
