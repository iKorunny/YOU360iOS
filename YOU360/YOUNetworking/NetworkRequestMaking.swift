//
//  NetworkRequestMaking.swift
//  YOUNetworking
//
//  Created by Ihar Karunny on 2/18/24.
//

import Foundation

public protocol NetworkRequestMaking {
    func makeRequest(with url: URL,
                     headerAcceptValue: String,
                     headerContentTypeValue: String,
                     authToken: String?,
                     method: RequestMethod,
                     json: [String: Any]?) -> URLRequest
    func makeAuthorizedRequest(with url: URL,
                               headerAcceptValue: String,
                               headerContentTypeValue: String,
                               token: String,
                               method: RequestMethod,
                               json: [String: Any]?) -> URLRequest
    func makeRefreshRequest(with url: URL,
                            headerAcceptValue: String,
                            headerContentTypeValue: String,
                            refreshToken: String,
                            method: RequestMethod) -> URLRequest
}

public enum RequestMethod: String {
    case post = "POST"
    case get = "GET"
}

public struct MultipartRequestTextField {
    let name: String
    let value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

public struct MultipartRequestDataField {
    let name: String
    let data: Data
    let mimeType: String
    let fileName: String?
    
    public init(name: String, data: Data, mimeType: String, fileName: String? = nil) {
        self.name = name
        self.data = data
        self.mimeType = mimeType
        self.fileName = fileName
    }
}

public final class NetworkRequestMaker: NetworkRequestMaking {
    
    static var shared = {
       return NetworkRequestMaker()
    }()
    
    public func makeRequest(with url: URL,
                            headerAcceptValue: String,
                            headerContentTypeValue: String,
                            authToken: String? = nil,
                            method: RequestMethod,
                            json: [String: Any]?) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.addValue(headerAcceptValue, forHTTPHeaderField: "Accept")
        request.addValue(headerContentTypeValue, forHTTPHeaderField: "Content-Type")
        if let authToken {
            request.addValue(authToken, forHTTPHeaderField: "x-token")
        }
        
        request.httpMethod = method.rawValue
        
        request.addValue(Locale.current.identifier, forHTTPHeaderField: "Accept-Language")
        
        if let json = json {
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])
        }
        
        return request
    }
    
    public func makeAuthorizedRequest(with url: URL, 
                                      headerAcceptValue: String,
                                      headerContentTypeValue: String,
                                      token: String,
                                      method: RequestMethod,
                                      json: [String : Any]?) -> URLRequest {
        var request = makeRequest(with: url, 
                                  headerAcceptValue: headerAcceptValue, 
                                  headerContentTypeValue: headerContentTypeValue, 
                                  method: method,
                                  json: json)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    public func makeRefreshRequest(with url: URL, 
                                   headerAcceptValue: String,
                                   headerContentTypeValue: String,
                                   refreshToken: String,
                                   method: RequestMethod) -> URLRequest {
        let request = makeRequest(with: url,
                                  headerAcceptValue: headerAcceptValue,
                                  headerContentTypeValue: headerContentTypeValue,
                                  method: method,
                                  json: [
                                    "refreshToken" : refreshToken
                                  ])
        
        return request
    }
    
    public func makeAuthorizedMultipartRequest(with url: URL, 
                                               token: String,
                                               textFields: [MultipartRequestTextField],
                                               dataFields: [MultipartRequestDataField]) -> URLRequest {
        let boundary = UUID().uuidString
        var bodyData = Data()
        
        for textField in textFields {
            bodyData.append(multipartRequestTextLine(from: textField, boundary: boundary).data(using: .utf8)!)
        }
        
        for dataField in dataFields {
            bodyData.append(multipartRequestDataLine(from: dataField, boundary: boundary))
//            // Convert the image into Data
//            let imageData = dataField.data
//            
//            let filename = "image0.jpg"
//            let mimetype = "image/jpg"
//            
//            // Add the image data to the body
//            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//            bodyData.append("Content-Disposition: form-data; name=\"\(dataField.name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//            bodyData.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
//            bodyData.append(imageData)
//            bodyData.append("\r\n".data(using: .utf8)!)

        }
        
        
        bodyData.append("--\(boundary)--".data(using: .utf8)!)
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        return request
    }
    
    private func multipartRequestTextLine(from model: MultipartRequestTextField, boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(model.name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(model.value)\r\n"
        
        return fieldString
    }
    
    private func multipartRequestDataLine(from model: MultipartRequestDataField, boundary: String) -> Data {
        var fieldData = Data()
        var fileName = model.fileName ?? ("\(model.name).jpg")
        
        fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
        fieldData.append("Content-Disposition: form-data; name=\"\(model.name)\"; filename=\"photo\(fileName)\"\r\n".data(using: .utf8)!)
        fieldData.append("Content-Type: \(model.mimeType)\r\n\r\n".data(using: .utf8)!)
        fieldData.append(model.data)
        fieldData.append("\r\n".data(using: .utf8)!)
        
        return fieldData
    }
}
