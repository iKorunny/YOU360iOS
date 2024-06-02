//
//  EventsNetworkService.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 6/2/24.
//

import Foundation
import YOUUtils

public final class EventsNetworkService: BaseSecretPartNetworkService {
    public static func makeService() -> EventsNetworkService {
        return EventsNetworkService()
    }
    
    /**
    GET
     */
    public func makeNearestEstablishmentsRequest(location: YOULocationManagerCoordinate,
                                                 maxDistance: Double? = nil,
                                                 page: RequestPage) {
        let baseUrl = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Establishment/nearest")
        var querryItems: [URLQueryItem] = []
        querryItems.append(URLQueryItem(name: "RequestAddressDto.Latitude", value: "\(location.latitude)"))
        querryItems.append(URLQueryItem(name: "RequestAddressDto.Longitude", value: "\(location.longitude)"))
        if let maxDistance {
            querryItems.append(URLQueryItem(name: "RequestAddressDto.MaxDistance", value: "\(maxDistance)"))
        }
        querryItems.append(URLQueryItem(name: "Offset", value: "\(page.offset)"))
        querryItems.append(URLQueryItem(name: "Size", value: "\(page.size)"))
        querryItems.append(contentsOf: page.jSON.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
        let url = baseUrl.appending(queryItems: querryItems)
        
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
