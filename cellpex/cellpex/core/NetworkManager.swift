//
//  NetworkManager.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/3/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class NetworkManager: NSObject {
    static func loginWithUserName(username: String, password:String, successHandler: @escaping ()->(), errorHandler: @escaping (_ errorMessage:String) ->()) {
        let loginURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.wsLogin
        let usernamebase64 = username.data(using: .utf8)?.base64EncodedString() ?? ""
        let passwordbase64 = password.data(using: .utf8)?.base64EncodedString() ?? ""
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let deviceIdbase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let firebaseToken = "tokenfirebaseToken".data(using: .utf8)?.base64EncodedString() ?? ""
        let brand = "Apple".data(using: .utf8)?.base64EncodedString() ?? ""
        let model = "iPhone6".data(using: .utf8)?.base64EncodedString() ?? ""
        let product = "product".data(using: .utf8)?.base64EncodedString() ?? ""
        let os = "IOS".data(using: .utf8)?.base64EncodedString() ?? ""
        let release = "11.1.0".data(using: .utf8)?.base64EncodedString() ?? ""
        let sdk = "iOS11".data(using: .utf8)?.base64EncodedString() ?? ""
        let screenResolution = "1040x2400".data(using: .utf8)?.base64EncodedString() ?? ""
        
        let params = ["username": usernamebase64,
                      "password": passwordbase64,
                      "deviceId": deviceIdbase64,
            "firebaseToken":firebaseToken,
            "brand":brand,
            "model":model,
            "product":product,
            "os":os,
            "release":release,
            "sdk":sdk,
            "screenResolution":screenResolution]
        var postContetn = ""
        for element in params {
            postContetn = "\(postContetn)&\(element.key)=\(element.value)"
        }
        
        var request = URLRequest.init(url: URL.init(string: loginURLString)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postContetn.data(using: .utf8)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let sessionTask = session.dataTask(with: request) { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            if data != nil{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    let responseDictionary = parsedData as? [String : Any?]
                    let errorValue = responseDictionary?["error"] as! String
                    if errorValue == "0" {
                        let dataDictionary = responseDictionary?["data"] as? [String : Any?]
                        let loadUserModelWithSuccess = SessionManager.manager.loadUserModel(dictinary: dataDictionary)
                        if loadUserModelWithSuccess {
                            successHandler()
                        } else {
                            errorHandler("Try again later!")
                        }
                    } else {
                        let message = (responseDictionary?["message"] as? String) ?? "Try again later!"
                        errorHandler(message)
                    }
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    errorHandler("Try again later!")
                    print("Details of JSON parsing error:\n \(error)")
                }
                
            }
        }
        sessionTask.resume()
        
    }
    
    static func logoutRequest() {
        let logoutURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.wsLogout
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let userID = SessionManager.manager.userModel?.id ?? ""
        let deviceIDBase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let userIDBase64 = userID.data(using: .utf8)?.base64EncodedString() ?? ""
        let params = ["userId": userIDBase64,
                      "deviceId": deviceIDBase64]
        var postContetn = ""
        for element in params {
            postContetn = "\(postContetn)&\(element.key)=\(element.value)"
        }
        
        var request = URLRequest.init(url: URL.init(string: logoutURLString)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postContetn.data(using: .utf8)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let sessionTask = session.dataTask(with: request) { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            if data != nil{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    let responseDictionary = parsedData as? [String : Any?]
                    print("\(String(describing: responseDictionary))")
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    print("Details of JSON parsing error:\n \(error)")
                }
            }
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.id.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.user.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.email.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.company.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.companyLogo.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.feedbackScore.rawValue)
        }
        sessionTask.resume()
    }
    
    
    static func getProduct(pageNumber: Int, successHandler: @escaping (_ products: [[String: Any?]?]? )->(), errorHandler: @escaping (_ errorMessage:String) ->()) {
        
        let getProductURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.getProduct
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let userID = SessionManager.manager.userModel?.id ?? ""
        let deviceIDBase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let userIDBase64 = userID.data(using: .utf8)?.base64EncodedString() ?? ""
        let params = ["userId": userIDBase64,
                      "deviceId": deviceIDBase64]
        var postContetn = ""
        for element in params {
            postContetn = "\(postContetn)&\(element.key)=\(element.value)"
        }
        
        var request = URLRequest.init(url: URL.init(string: getProductURLString)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postContetn.data(using: .utf8)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let sessionTask = session.dataTask(with: request) { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            if data != nil{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    let responseDictionary = parsedData as? [String : Any?]
                    let productsArray = responseDictionary?["data"] as? [[String: Any?]?]
                    successHandler(productsArray)
                    print("\(String(describing: responseDictionary))")
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    print("Details of JSON parsing error:\n \(error)")
                }
            }
        }
        sessionTask.resume()
    }
}


