//
//  ProfileNetworkService.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 4/5/24.
//

import Foundation
import UIKit
import YOUUtils

public final class ProfileNetworkService: BaseSecretPartNetworkService {
    public static func makeService() -> ProfileNetworkService {
        return ProfileNetworkService()
    }
    
    public func makeSecretPageRequest() {
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
    
    public func makeUpdateProfileRequest(id: String,
                                  email: String,
                                  username: String,
                                  name: String?,
                                  surname: String?,
                                  aboutMe: String?,
                                  dateOfBirth: Date?,
                                  city: String?,
                                  paymentMethod: String?,
                                  instagram: String?,
                                  facebook: String?,
                                  twitter: String?,
                                  avatar: UIImage?,
                                  isAvatarUpdated: Bool,
                                  banner: UIImage?,
                                  isBannerUpdated: Bool,
                                  completion: @escaping ((Bool, UserInfoResponse?, SecretPartNetworkLocalError?) -> Void)) {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Profile/UpdateProfileInfo")

        var multipartTextFields: [MultipartRequestTextField] = [
            MultipartRequestTextField(name:"Id", value: id),
            MultipartRequestTextField(name:"Email", value: email),
            MultipartRequestTextField(name:"UserName", value: username)
        ]
        
        if let name = name {
            multipartTextFields.append(MultipartRequestTextField(name:"Name", value: name))
        }
        if let surname = surname {
            multipartTextFields.append(MultipartRequestTextField(name:"Surname", value: surname))
        }
        if let aboutMe = aboutMe {
            multipartTextFields.append(MultipartRequestTextField(name:"AboutMe", value: aboutMe))
        }
        if let dateOfBirth = dateOfBirth,
            let dateOfBirthString = Formatters.dateOfBirthNetworkFormatter.toString(date: dateOfBirth) {
            multipartTextFields.append(MultipartRequestTextField(name:"DateOfBirth", value: dateOfBirthString))
        }
        if let city = city {
            multipartTextFields.append(MultipartRequestTextField(name:"City", value: city))
        }
        if let paymentMethod = paymentMethod {
            multipartTextFields.append(MultipartRequestTextField(name:"PaymentMethod", value: paymentMethod))
        }
        if let instagram = instagram {
            multipartTextFields.append(MultipartRequestTextField(name:"Instagram", value: instagram))
        }
        if let facebook = facebook {
            multipartTextFields.append(MultipartRequestTextField(name:"Facebook", value: facebook))
        }
        if let twitter = twitter {
            multipartTextFields.append(MultipartRequestTextField(name:"Twitter", value: twitter))
        }
        multipartTextFields.append(MultipartRequestTextField(name:"IsAvatarUpdated", value: "\(isAvatarUpdated)"))
        multipartTextFields.append(MultipartRequestTextField(name:"IsBackgroundUpdated", value: "\(isBannerUpdated)"))
        
        var multipartImageFields: [MultipartRequestDataField] = []
        if let avatar = avatar,
            let avatarData = avatar.jpegData(compressionQuality: 1.0) {
            multipartImageFields.append(MultipartRequestDataField.init(name: "AvatarFile", data: avatarData, mimeType: "image/jpeg"))
        }
        if let banner = banner,
            let bannerData = banner.jpegData(compressionQuality: 1.0) {
            multipartImageFields.append(MultipartRequestDataField.init(name: "BackgroundFile", data: bannerData, mimeType: "image/jpeg"))
        }
        
        let request = requestMaker.makeAuthorizedMultipartRequest(with: url,
                                                                  token: secretNetworkService.authToken,
                                                                  textFields: multipartTextFields,
                                                                  dataFields: multipartImageFields)
        
        secretNetworkService.performDataTask(request: request) { data, response, error, localError in
            guard error == nil && localError == nil,
                  response?.isSuccess == true,
                  let data = data else {
                DispatchQueue.main.async {
                    completion(false, nil, localError)
                }
                return
            }

            let profile: UserInfoResponse? = try? JSONDecoder().decode(UserInfoResponse.self, from: data)
            DispatchQueue.main.async {
                completion(profile != nil, profile, localError)
            }
        }
    }
    
    public func makeUploadImagePostRequest(id: String,
                                    image: UIImage,
                                    completion: @escaping ((Bool, SecretPartNetworkLocalError?) -> Void)) {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Post")
        
        let multipartTextFields: [MultipartRequestTextField] = [
            MultipartRequestTextField(name:"UserAuthorId", value: id),
            MultipartRequestTextField(name:"PublicationDelay", value: "0"),
            MultipartRequestTextField(name:"Visibility", value: "1"),
            MultipartRequestTextField(name:"Description", value: "")
        ]
        
        
        guard let postData = image.jpegData(compressionQuality: 1.0) else {
            DispatchQueue.main.async {
                completion(false, nil)
            }
            return
        }
        let multipartImageFields: [MultipartRequestDataField] = [MultipartRequestDataField(name: "PostsFiles", data: postData, mimeType: "image/jpeg", fileName: "contentFile0")]
        
        let request = requestMaker.makeAuthorizedMultipartRequest(with: url,
                                                                  token: secretNetworkService.authToken,
                                                                  textFields: multipartTextFields,
                                                                  dataFields: multipartImageFields)
        
        secretNetworkService.performDataTask(request: request) { data, response, error, localError in
            guard error == nil && localError == nil,
            response?.isSuccess == true else {
                DispatchQueue.main.async {
                    completion(false, localError)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(true, localError)
            }
        }
    }
    
    public func makeDownloadImageGetRequest(imagePath: String,
                                    completion: @escaping ((UIImage?) -> Void)) {
        
        let url = URL(string: imagePath)!
        
        let _ = ContentLoaders.imageLoader.dataTaskToLoadImage(with: url) { image in
            DispatchQueue.main.async() {
                completion(image)
            }
        }
    }
    
    public func makeProfileRequest(id: String, completion: @escaping (Bool, UserInfoResponse?, SecretPartNetworkLocalError?) -> Void) {
        let url = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("User/\(id)")
        
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

            let profile: UserInfoResponse? = try? JSONDecoder().decode(UserInfoResponse.self, from: data)
            DispatchQueue.main.async {
                completion(profile != nil, profile, localError)
            }
        }
    }
    
    /*
     {
       "items": [
         {
           "id": "4c02014c-974d-4db1-8513-ea18c13b31b8",
           "description": "Trololo",
           "visibility": 1,
           "publicationDate": "0001-01-01T00:00:00",
           "contents": [
             {
               "id": "105f1f23-3c71-45a4-8c59-13bf8ff3ef44",
               "contentUrl": "https://storage.googleapis.com/download/storage/v1/b/you360-bucket/o/Post%2FContent%2FImage%2FContent%2F105f1f23-3c71-45a4-8c59-13bf8ff3ef44?generation=1715598804925922&alt=media",
               "previewUrl": "https://storage.googleapis.com/download/storage/v1/b/you360-bucket/o/Post%2FContent%2FImage%2FPreview%2F105f1f23-3c71-45a4-8c59-13bf8ff3ef44?generation=1715598805156460&alt=media",
               "contentTypeFull": "image/png",
               "contentTypeCompressed": "image/jpeg",
               "contentName": "Post/Content/Image/Content/105f1f23-3c71-45a4-8c59-13bf8ff3ef44",
               "previewName": "Post/Content/Image/Preview/105f1f23-3c71-45a4-8c59-13bf8ff3ef44"
             }
           ],
           "userAuthor": {
             "id": "f72d4638-43ff-49f5-bae5-dd0d769398f1",
             "email": null,
             "userName": null,
             "name": "Andy",
             "surname": null,
             "aboutMe": null,
             "dateOfBirth": null,
             "city": null,
             "paymentMethod": null,
             "instagram": null,
             "facebook": null,
             "twitter": null,
             "postsCount": 0,
             "ticketsCount": 0,
             "likedEventsCount": 0,
             "establishmentsSubscriptionsCount": 0,
             "reservationsCount": 0,
             "avatar": null,
             "avatarId": null,
             "background": null,
             "backgroundId": null,
             "verification": 0,
             "establishmentId": null
           },
           "userAuthorId": "f72d4638-43ff-49f5-bae5-dd0d769398f1",
           "establishmentAuthor": null,
           "establishmentAuthorId": null,
           "likesCount": 0,
           "commentsCount": 0
         }
       ],
       "offset": 0,
       "size": 100,
       "totalCount": 1,
       "hasNextItem": false,
       "hasPreviousItem": false
     }

     */
    
    public func makeProfileMediaRequest(id: String, page: RequestPage, completion: @escaping (Bool, [ProfileContent]?, SecretPartNetworkLocalError?) -> Void) {
        let baseUrl = URL(string: AppNetworkConfig.V1.backendAddress)!.appendingPathComponent("Post/")
        var querryItems: [URLQueryItem] = []
        querryItems.append(URLQueryItem(name: "userId", value: id))
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
                    completion(false, [], localError)
                }
                return
            }
            
            let contentPage: ProfileContentPage? = try? JSONDecoder().decode(ProfileContentPage.self, from: data)
            DispatchQueue.main.async {
                completion(contentPage != nil, contentPage?.items, localError)
            }
        }
    }
}
