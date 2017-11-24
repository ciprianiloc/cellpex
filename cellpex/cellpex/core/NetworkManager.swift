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
import SafariServices

class NetworkManager: NSObject {
    static func gedDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        let modelInfo = modelCode ?? "unknow"
        return modelInfo
    }
    
    static func redirectToWeb(parentVC: UIViewController, endPoint: String) {
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let redirectURL = URLConstant.redirectURL + "&deviceId=\(deviceId)&redirectTo=\(endPoint)"
        if let url = URL(string: redirectURL) {
            let svc = SFSafariViewController(url: url)
            parentVC.present(svc, animated: true, completion: nil)
        }
    }
    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    static func loginWithUserName(username: String, password:String, successHandler: @escaping ()->(), errorHandler: @escaping (_ errorMessage:String) ->()) {
        let loginURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.wsLogin
        let usernamebase64 = username.data(using: .utf8)?.base64EncodedString() ?? ""
        let passwordbase64 = password.data(using: .utf8)?.base64EncodedString() ?? ""
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let deviceIdbase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let firebaseToken = "tokenfirebaseToken".data(using: .utf8)?.base64EncodedString() ?? ""
        let brand = "Apple".data(using: .utf8)?.base64EncodedString() ?? ""
        let model = NetworkManager.gedDeviceModel().data(using: .utf8)?.base64EncodedString() ?? ""
        let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
        let product = version.data(using: .utf8)?.base64EncodedString() ?? ""
        let os = "IOS".data(using: .utf8)?.base64EncodedString() ?? ""
        let release = UIDevice.current.systemVersion.data(using: .utf8)?.base64EncodedString() ?? ""
        let sdk = "iOS11".data(using: .utf8)?.base64EncodedString() ?? ""
        let height = (UIScreen.main.bounds.size.height * UIScreen.main.scale)
        let width = (UIScreen.main.bounds.size.width * UIScreen.main.scale)
        let screenResolution = "\(width)x\(height)".data(using: .utf8)?.base64EncodedString() ?? ""
        
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
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.id.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.user.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.email.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.company.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.companyLogo.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainUserModel.feedbackScore.rawValue)
        }
        sessionTask.resume()
    }
    
    
    static func getProduct(search:String?,endPoint:String, successHandler: @escaping (_ products: [[String: Any?]?]? )->(), errorHandler: @escaping (_ errorMessage:String) ->()) {
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let userID = SessionManager.manager.userModel?.id ?? ""
        let deviceIDBase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let userIDBase64 = userID.data(using: .utf8)?.base64EncodedString() ?? ""
        var params = ["userId": userIDBase64,
                      "deviceId": deviceIDBase64]
        if let search_string = search {
            let searchBase64 = search_string.data(using: .utf8)?.base64EncodedString() ?? ""
            params["search"] = searchBase64
        }
        var postContetn = ""
        for element in params {
            postContetn = "\(postContetn)&\(element.key)=\(element.value)"
        }
        
        let getProductURLString = WebServices.devHostName + WebServices.apiToUse + endPoint
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
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    print("Details of JSON parsing error:\n \(error)")
                }
            }
        }
        sessionTask.resume()
    }
    
    static func getProductDetails(product: ProductModel, successHandler: @escaping (_ productDetails: [String: Any?]? )->(), errorHandler: @escaping (_ errorMessage:String) ->()) {
        
        let getProductURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.getProductDetails
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let userID = SessionManager.manager.userModel?.id ?? ""
        let postId = product.id ?? ""
        let deviceIDBase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let userIDBase64 = userID.data(using: .utf8)?.base64EncodedString() ?? ""
        let postIdBase64 = postId.data(using: .utf8)?.base64EncodedString() ?? ""
        let params = ["userId": userIDBase64,
                      "deviceId": deviceIDBase64,
                      "postId":postIdBase64]
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
                    let productsArray = responseDictionary?["data"] as? [String: Any?]
                    successHandler(productsArray)
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    print("Details of JSON parsing error:\n \(error)")
                }
            }
        }
        sessionTask.resume()
    }
    
    static func getUnreadMessageCount(updateNumberOfMessageHandler: @escaping (_ numberOfMessage:Int) ->()) {
        let getUnreadURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.getUnreadMessageCounter
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
        
        var request = URLRequest.init(url: URL.init(string: getUnreadURLString)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postContetn.data(using: .utf8)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let sessionTask = session.dataTask(with: request) { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            if data != nil{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    let responseDictionary = parsedData as? [String : Any?]
                    let responseData = responseDictionary?["data"] as? [String : Any?]
                    let number = responseData?["nr"] as? Int ?? 0
                    updateNumberOfMessageHandler(number)
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    print("Details of JSON parsing error:\n \(error)")
                }
            }
        }
        sessionTask.resume()
    }
    
    static func sendMessage(postId: String, subject: String, message: String, sendMessageHandler: @escaping (_ message:String) ->()) {
        let getUnreadURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.sendMessage
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let userID = SessionManager.manager.userModel?.id ?? ""
        let deviceIDBase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let userIDBase64 = userID.data(using: .utf8)?.base64EncodedString() ?? ""
        let postId64 = postId.data(using: .utf8)?.base64EncodedString() ?? ""
        let subject64 = subject.data(using: .utf8)?.base64EncodedString() ?? ""
        let message64 = message.data(using: .utf8)?.base64EncodedString() ?? ""
        let params = ["userId": userIDBase64,
                      "deviceId": deviceIDBase64,
                      "postId":  postId64,
                      "subject": subject64,
                      "message": message64]
        
        var postContetn = ""
        for element in params {
            postContetn = "\(postContetn)&\(element.key)=\(element.value)"
        }
        
        var request = URLRequest.init(url: URL.init(string: getUnreadURLString)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postContetn.data(using: .utf8)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let sessionTask = session.dataTask(with: request) { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            if data != nil{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    let responseDictionary = parsedData as? [String : Any?]
                    let responseData = (responseDictionary?["message"] as? String) ?? "Some error appears. Please try again!"
                    sendMessageHandler(responseData)
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    sendMessageHandler("Some error appears. Please try again!")
                    print("Details of JSON parsing error:\n \(error)")
                }
            }
        }
        sessionTask.resume()
    }
    
    
    static func sendFeedback(subject: String, message: String, sendMessageHandler: @escaping (_ message:String) ->()) {
        let getUnreadURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.sendFeedbackMessage
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let userID = SessionManager.manager.userModel?.id ?? ""
        let deviceIDBase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let userIDBase64 = userID.data(using: .utf8)?.base64EncodedString() ?? ""
        let subject64 = subject.data(using: .utf8)?.base64EncodedString() ?? ""
        let message64 = message.data(using: .utf8)?.base64EncodedString() ?? ""
        let params = ["userId": userIDBase64,
                      "deviceId": deviceIDBase64,
                      "subject": subject64,
                      "message": message64]
        
        var postContetn = ""
        for element in params {
            postContetn = "\(postContetn)&\(element.key)=\(element.value)"
        }
        
        var request = URLRequest.init(url: URL.init(string: getUnreadURLString)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postContetn.data(using: .utf8)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let sessionTask = session.dataTask(with: request) { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            if data != nil{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    let responseDictionary = parsedData as? [String : Any?]
                    let responseData = (responseDictionary?["message"] as? String) ?? "Some error appears. Please try again!"
                    sendMessageHandler(responseData)
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    sendMessageHandler("Some error appears. Please try again!")
                    let dataString = String.init(data: data!, encoding: .utf8) ?? ""
                    print("Details of JSON parsing error:\n\(error) \n string = \(dataString)")
                }
            }
        }
        sessionTask.resume()
    }
    
    static func getMessages(endPoint:String, successHandler: @escaping (_ products: [[String: Any?]?]? )->(), errorHandler: @escaping (_ errorMessage:String) ->())  {
        let getUnreadURLString = WebServices.devHostName + WebServices.apiToUse + endPoint
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
        
        var request = URLRequest.init(url: URL.init(string: getUnreadURLString)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postContetn.data(using: .utf8)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let sessionTask = session.dataTask(with: request) { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            if data != nil{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    let responseDictionary = parsedData as? [String : Any?]
                    let messagesArray = responseDictionary?["data"] as? [[String: Any?]?]
                    successHandler(messagesArray)
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    print("Details of JSON parsing error:\n \(error)")
                }
            }
        }
        sessionTask.resume()
    }
    
    static func getMessage(messageId: String, endPoint:String, successHandler: @escaping (_ message: [String: Any?]? )->(), errorHandler: @escaping (_ errorMessage:String) ->())  {
        let getUnreadURLString = WebServices.devHostName + WebServices.apiToUse + endPoint
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let userID = SessionManager.manager.userModel?.id ?? ""
        let deviceIDBase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let userIDBase64 = userID.data(using: .utf8)?.base64EncodedString() ?? ""
        let messageId64 = messageId.data(using: .utf8)?.base64EncodedString() ?? ""
        let params = ["userId": userIDBase64,
                      "deviceId": deviceIDBase64,
                      "messageId": messageId64]
        var postContetn = ""
        for element in params {
            postContetn = "\(postContetn)&\(element.key)=\(element.value)"
        }
        
        var request = URLRequest.init(url: URL.init(string: getUnreadURLString)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postContetn.data(using: .utf8)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let sessionTask = session.dataTask(with: request) { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            if data != nil{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    let responseDictionary = parsedData as? [String : Any?]
                    let message = responseDictionary?["data"] as? [String: Any?]
                    successHandler(message)
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    print("Details of JSON parsing error:\n \(error)")
                    let dataString = String.init(data: data!, encoding: .utf8) ?? ""
                    print("Details of JSON parsing error:\n\(error) \n string = \(dataString)")
                }
            }
        }
        sessionTask.resume()
    }
    
    static func sendReply(messageId: String, senderId: String, message: String, sendMessageHandler: @escaping (_ message:String) ->()) {
        let getUnreadURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.sendReplyMessage
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let userID = SessionManager.manager.userModel?.id ?? ""
        let deviceIDBase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
        let userIDBase64 = userID.data(using: .utf8)?.base64EncodedString() ?? ""
        let messageId64 = messageId.data(using: .utf8)?.base64EncodedString() ?? ""
        let message64 = message.data(using: .utf8)?.base64EncodedString() ?? ""
        let senderId64 = senderId.data(using: .utf8)?.base64EncodedString() ?? ""
        let params = ["userId": userIDBase64,
                      "deviceId": deviceIDBase64,
                      "messageId": messageId64,
                      "senderId": senderId64,
                      "message": message64]
        
        var postContetn = ""
        for element in params {
            postContetn = "\(postContetn)&\(element.key)=\(element.value)"
        }
        
        var request = URLRequest.init(url: URL.init(string: getUnreadURLString)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = postContetn.data(using: .utf8)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConfiguration)
        let sessionTask = session.dataTask(with: request) { (data: Data?, urlresponse: URLResponse?, error: Error?) in
            
            if data != nil{
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    let responseDictionary = parsedData as? [String : Any?]
                    let responseData = (responseDictionary?["message"] as? String) ?? "Some error appears. Please try again!"
                    sendMessageHandler(responseData)
                }
                    //else throw an error detailing what went wrong
                catch let error as NSError {
                    sendMessageHandler("Some error appears. Please try again!")
                    let dataString = String.init(data: data!, encoding: .utf8) ?? ""
                    print("Details of JSON parsing error:\n\(error) \n string = \(dataString)")
                }
            }
        }
        sessionTask.resume()
    }
}


