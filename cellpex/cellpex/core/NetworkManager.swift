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
    static func loginWithUserName(username: String, password:String) {
        let loginURLString = WebServices.devHostName + WebServices.apiToUse + WebServices.wsLogin
        let usernamebase64 = username.data(using: .utf8)?.base64EncodedString() ?? ""
        let passwordbase64 = password.data(using: .utf8)?.base64EncodedString() ?? ""
        let deviceId = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) ?? ""
        let deviceIdbase64 = deviceId.data(using: .utf8)?.base64EncodedString() ?? ""
//        let parameter = ["username":usernamebase64, "password" : passwordbase64,"deviceId":deviceIdbase64] as! [String : String]
        
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
                    
                    //Store response in NSDictionary for easy access
                    let dict = parsedData as? NSDictionary
                    print("\(parsedData)");
                    
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
        
//        Alamofire.request(URL(string: loginURLString)!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
//
//                   }
        
//        Alamofire.request(URL(string: loginURLString)!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).response { (data) in
//
//        }
        

        
//        Alamofire.request(loginURLString,method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted, headers: [:]).responseData { (response:DataResponse<Data>) in
//
//            switch(response.result) {
//
//            case .success(_):
//
//                if response.result.value != nil
//
//                            {
//                                print("response : \(response.result.value!)")
//                                let str = String.init(data: response.data!, encoding: .utf8)
//                                print("response : \(String(describing: str))")
//                            }
//                            else
//                            {
//                                print("Error")
//                            }
//                            break
//                        case .failure(_):
//                            print("Failure : \(response.result.error!)")
//                            break
//                        }
//                    }

//        Alamofire.request(loginURLString,method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted, headers: [:]).responseJSON { (response:DataResponse<Any>) in
//
//            switch(response.result) {
//            case .success(_):
//                if response.result.value != nil
//
//                {
//                    print("response : \(response.result.value!)")
//                }
//                else
//                {
//                    print("Error")
//                }
//                break
//            case .failure(_):
//                print("Failure : \(response.result.error!)")
//                break
//            }
//        }


