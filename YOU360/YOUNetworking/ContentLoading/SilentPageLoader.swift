//
//  SilentPageLoader.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 6/14/24.
//

import Foundation

public protocol PageLoaderDataSource {
    associatedtype DataType: Codable
    func makeRequest(with page: RequestPage, completion: @escaping (Bool, PageResponse<DataType>?, SecretPartNetworkLocalError?) -> Void)
}

public protocol PageLoaderDelegate {
    associatedtype T: Codable
    func didLoadPage(offset: Int, with items: [T])
}

public final class SilentPageLoader<T: Codable, TSource: PageLoaderDataSource, TDelegate: PageLoaderDelegate> where T == TSource.DataType, T == TDelegate.T {
    let pageSize: Int
    let dataSource: TSource
    let delegate: TDelegate
    
    public init(pageSize: Int, dataSource: TSource, delegate: TDelegate) {
        self.pageSize = pageSize
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    public func restartRequest(completion: @escaping (Bool, PageResponse<T>?, SecretPartNetworkLocalError?) -> Void) {
        dataSource.makeRequest(with: .init(offset: 0, size: pageSize)) { [weak self] success, pageResponse, error in
            completion(success, pageResponse, error)
            self?.loadNextPageIfNeeded(lastSuccess: success, lastPageLoaded: pageResponse)
        }
    }
    
    private func loadNextPageIfNeeded(lastSuccess: Bool, lastPageLoaded: PageResponse<T>?) {
        guard lastSuccess,
              let lastPage = lastPageLoaded,
              lastPage.hasNextItem else { return }
        dataSource.makeRequest(with: .init(offset: lastPage.offset + lastPage.items.count, size: pageSize)) { [weak self] success, pageResponse, _ in
            if success, let response = pageResponse {
                self?.delegate.didLoadPage(offset: response.offset, with: response.items)
            }
            
            self?.loadNextPageIfNeeded(lastSuccess: success, lastPageLoaded: pageResponse)
        }
    }
}
