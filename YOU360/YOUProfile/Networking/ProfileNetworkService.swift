//
//  ProfileNetworkService.swift
//  YOUProfile
//
//  Created by Ihar Karunny on 4/5/24.
//

import Foundation
import YOUNetworking
import UIKit
import YOUProfileInterfaces
import YOUUtils

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
    
    func makeUpdateProfileRequest(id: String,
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
                                  completion: @escaping ((Bool, Profile?) -> Void)) {
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
            multipartImageFields.append(MultipartRequestDataField.init(name: "PhotoAvatar", data: avatarData, mimeType: "image/jpeg"))
        }
        if let banner = banner,
            let bannerData = banner.jpegData(compressionQuality: 1.0) {
            multipartImageFields.append(MultipartRequestDataField.init(name: "PhotoBackground", data: bannerData, mimeType: "image/jpeg"))
        }
        
        let request = requestMaker.makeAuthorizedMultipartRequest(with: url,
                                                                  token: secretNetworkService.authToken,
                                                                  textFields: multipartTextFields,
                                                                  dataFields: multipartImageFields)
        
        secretNetworkService.performDataTask(request: request) { data, response, error, localError in
            guard error == nil && localError == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }

            let profile: Profile? = try? JSONDecoder().decode(Profile.self, from: data)
            DispatchQueue.main.async {
                completion(profile != nil, profile)
            }
        }
    }
}
