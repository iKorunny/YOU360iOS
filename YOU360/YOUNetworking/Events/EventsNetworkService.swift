//
//  EventsNetworkService.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 6/2/24.
//

import Foundation
import YOUUtils

public protocol EventsNetworkServiceDataSource {
    var location: YOULocationManagerCoordinate? { get }
    var maxDistance: Double? { get }
}

public final class EventsNetworkService: BaseSecretPartNetworkService, PageLoaderDataSource {
    public typealias DataType = EstablishmentWithEvents
    
    public var dataSource: EventsNetworkServiceDataSource?
    
    public static func makeService() -> EventsNetworkService {
        return EventsNetworkService()
    }
    
    public func makeRequest(with page: RequestPage, completion: @escaping (Bool, PageResponse<DataType>?, SecretPartNetworkLocalError?) -> Void) {
        guard let location = dataSource?.location else {
            completion(false, nil, .general)
            return
        }
        
        makeNearestEstablishmentsRequest(location: location,
                                         maxDistance: dataSource?.maxDistance,
                                         page: page,
                                         completion: completion)
    }
    
    /**
    GET
     */
    public func makeNearestEstablishmentsRequest(location: YOULocationManagerCoordinate,
                                                 maxDistance: Double? = nil,
                                                 page: RequestPage,
                                                 completion: @escaping (Bool, PageResponse<DataType>?, SecretPartNetworkLocalError?) -> Void) {
        let baseUrl = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Establishment/nearest")
        var querryItems: [URLQueryItem] = []
        querryItems.append(URLQueryItem(name: "RequestAddressDto.Latitude", value: "10"))
        querryItems.append(URLQueryItem(name: "RequestAddressDto.Longitude", value: "10"))
        querryItems.append(URLQueryItem(name: "RequestAddressDto.MaxDistance", value: "40"))
        //TODO: Uncomment!!!!
//        querryItems.append(URLQueryItem(name: "RequestAddressDto.Latitude", value: "\(location.latitude)"))
//        querryItems.append(URLQueryItem(name: "RequestAddressDto.Longitude", value: "\(location.longitude)"))
//        if let maxDistance {
//            querryItems.append(URLQueryItem(name: "RequestAddressDto.MaxDistance", value: "\(maxDistance)"))
//        }
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
            guard error == nil && localError == nil,
                  response?.isSuccess == true,
                  let data = data else {
                DispatchQueue.main.async {
                    completion(false, nil, localError)
                }
                return
            }

            let page: PageResponse<DataType>? = try? JSONDecoder().decode(PageResponse<DataType>.self, from: data)
            DispatchQueue.main.async {
                completion(page != nil, page, localError)
            }
        }
    }
}
