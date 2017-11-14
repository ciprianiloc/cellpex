//
//  UserModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/14/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

public enum ServerUserModel: String {
    case user = "user"
    case email = "email"
    case id = "id"
    case feedbackScore = "feedbackScore"
    case company = "company"
    case companyLogo = "companyLogo"
}

public enum KeychainUserModel: String {
    case user = "user_key"
    case email = "email_key"
    case id = "id_key"
    case feedbackScore = "feedbackScore_key"
    case company = "company_key"
    case companyLogo = "companyLogo_key"
}

struct UserModel {
    var user : String?
    var email : String?
    var id : String?
    var feedbackScore :String
    var company : String
    var companyLogo : String
    
    
    init(dictionary: [String: String]?) {
        guard let userDictionary = dictionary else {
            user = KeychainWrapper.standard.string(forKey: KeychainUserModel.user.rawValue)
            email = KeychainWrapper.standard.string(forKey: KeychainUserModel.email.rawValue)
            id = KeychainWrapper.standard.string(forKey: KeychainUserModel.id.rawValue)
            feedbackScore = KeychainWrapper.standard.string(forKey: KeychainUserModel.feedbackScore.rawValue) ?? "0"
            company = KeychainWrapper.standard.string(forKey: KeychainUserModel.company.rawValue) ?? "NoCompany"
            companyLogo = KeychainWrapper.standard.string(forKey: KeychainUserModel.companyLogo.rawValue) ?? URLConstant.noLogoURL
            return
        }
        user = userDictionary[ServerUserModel.user.rawValue]
        email = userDictionary[ServerUserModel.email.rawValue]
        id = userDictionary[ServerUserModel.id.rawValue]
        feedbackScore = userDictionary[ServerUserModel.feedbackScore.rawValue] ?? "0"
        company = userDictionary[ServerUserModel.company.rawValue] ?? "NoCompany"
        companyLogo = userDictionary[ServerUserModel.companyLogo.rawValue] ?? URLConstant.noLogoURL
        guard let _ = user, let _ = email, let _ = id else {
            return
        }
        KeychainWrapper.standard.set(user!, forKey: KeychainUserModel.user.rawValue)
        KeychainWrapper.standard.set(email!, forKey: KeychainUserModel.email.rawValue)
        KeychainWrapper.standard.set(id!, forKey: KeychainUserModel.id.rawValue)
        KeychainWrapper.standard.set(feedbackScore, forKey: KeychainUserModel.feedbackScore.rawValue)
        KeychainWrapper.standard.set(company, forKey: KeychainUserModel.company.rawValue)
        KeychainWrapper.standard.set(companyLogo, forKey: KeychainUserModel.companyLogo.rawValue)
    }

}
