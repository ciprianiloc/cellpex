//
//  RegisterModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 12/16/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

enum RegistrationField: Int {
    case Username = 0
    case Password = 1
    case RetypePassword = 2
    case EmailAddress = 3
    case EmailAddressAgain = 4
    case FistName = 5
    case LastName = 6
    case CompanyName = 7
    case EINorVTACode = 8
    case LicenseOrRegitrationNumber = 9
    case Country = 10
    case StateOrProvince = 11
    case Timezone = 12
    case AddressLine1 = 13
    case AddressLine2 = 14
    case City = 15
    case ZipOrPostalCode = 16
    case Phone = 17
    case MobilePhone = 18
    case Fax = 19
    case Website = 20
    case SkypeID = 21
    case BlackberryPIN = 22
    case HowDidYouHearAboutUs = 23
    case PromotionalCode = 24
    case DBDUNSNo = 25
    
    var title: String {
        switch self {
        case .Username: return "Pick a Username"
        case .Password: return "Password"
        case .RetypePassword: return "Retype New Password"
        case .EmailAddress: return "Email address"
        case .EmailAddressAgain: return "Email address again"
        case .FistName: return "Fist Name"
        case .LastName: return "Last Name"
        case .CompanyName: return "Company Name"
        case .EINorVTACode: return "EIN/GST or VTA code"
        case .LicenseOrRegitrationNumber: return "License or Regitration number"
        case .Country: return "Country"
        case .StateOrProvince: return "State or Province"
        case .Timezone: return "Timezone"
        case .AddressLine1: return "Address Line 1"
        case .AddressLine2: return "Address Line 2"
        case .City: return "City"
        case .ZipOrPostalCode: return "Zip or Postal Code"
        case .Phone: return "Phone"
        case .MobilePhone: return "Mobile Phone"
        case .Fax: return "Fax"
        case .Website:return "Website"
        case .SkypeID: return "Skype ID"
        case .BlackberryPIN: return "Blackberry PIN"
        case .HowDidYouHearAboutUs: return "How did you hear about us"
        case .PromotionalCode: return "Promotional Code"
        case .DBDUNSNo : return "D&B D-U-N-S® No."
        }
    }
    
    var additionalInfo: String {
        switch self {
        case .Username: return "Username may consist of a-z, A-Z, 0-9. Don't use special characters!"
        case .Password: return "Six characters or more; capitalization matters!"
        case .EmailAddress: return "Do not use free emails if you care about reputation."
        case .CompanyName: return "Sale-Traders type name again"
        case .EINorVTACode: return "Sales tax id mandatory for sellers"
        case .LicenseOrRegitrationNumber: return "This field is mandatory for sellers"
        case .Phone: return "* select country code if other"
        case .MobilePhone: return "* select country code if other"
        case .Fax: return "* select country code if other"
        case .PromotionalCode: return "Refferal code, discount coupon, etc."
        case .DBDUNSNo : return "What's this?"
        default: return ""
        }
    }

    var isMandatoryForBayer: Bool {
        switch self {
        case .EINorVTACode: return false
        case .LicenseOrRegitrationNumber : return false
        case .AddressLine2: return false
        case .MobilePhone: return false
        case .Fax: return false
        case .Website: return false
        case .SkypeID: return false
        case .BlackberryPIN: return false
        case .HowDidYouHearAboutUs: return false
        case .PromotionalCode: return false
        case .DBDUNSNo: return false
        default: return true
        }
    }
    
    var isMandatoryForSeller: Bool {
        switch self {
        case .EINorVTACode: return true
        case .LicenseOrRegitrationNumber: return true
        default: return isMandatoryForBayer
        }
    }
}

class RegisterModel: NSObject {

}
