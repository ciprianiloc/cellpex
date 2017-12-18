//
//  RegisterLoginDetailsModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 18/12/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

enum RegisterLoginDetailsField: Int {
    case Username = 0
    case Password = 1
    case RetypePassword = 2
    case EmailAddress = 3
    case EmailAddressAgain = 4
    
    var title: String {
        switch self {
        case .Username: return "Pick a Username"
        case .Password: return "Password"
        case .RetypePassword: return "Retype New Password"
        case .EmailAddress: return "Email address"
        case .EmailAddressAgain: return "Email address again"
        }
    }
    
    var additionalInfo: String {
        switch self {
        case .Username: return "Username may consist of a-z, A-Z, 0-9. Don't use special characters!"
        case .Password: return "Six characters or more; capitalization matters!"
        case .EmailAddress: return "Do not use free emails if you care about reputation."
        default: return ""
        }
    }
    
}

class RegisterLoginDetailsModel: NSObject {

}
