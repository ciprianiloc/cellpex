//
//  NetworkManager.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/3/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    static func loginWithUserName(username: String, password:String) {
        let loginURLString = WebServices.productionHostName + WebServices.apiToUse + WebServices.wsLogin
        let parameter = ["username":username, "password" : password, ]
        Alamofire.request(URL(string: loginURLString)!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
                   }
    }
}
