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
        
        let params = ["username": usernamebase64,
                      "password": passwordbase64,
                      "deviceId": deviceIdbase64,
            "firebaseToken":"token",
            "device":"iPhone",
            "model":"model",
            "product":"product",
            "os":"IOS",
            "release":"10.0.3",
            "sdk":"11",
            "screenResolution":"test"]

        
//        Alamofire.request(URL(string: loginURLString)!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
//
//                   }
        
//        Alamofire.request(URL(string: loginURLString)!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).response { (data) in
//
//        }
        
        Alamofire.request(loginURLString,method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted, headers: [:]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil
                    
                {
                    print("response : \(response.result.value!)")
                }
                else
                {
                    print("Error")
                }
                break
            case .failure(_):
                print("Failure : \(response.result.error!)")
                break
            }
        }
    }
    
    }

