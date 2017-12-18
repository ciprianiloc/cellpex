//
//  RegisterAccountDetailsModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 18/12/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

enum RegistrationAccountDetailsField: Int {
    case FistName = 0
    case LastName = 1
    case CompanyName = 2
    case EINorVTACode = 3
    case LicenseOrRegitrationNumber = 4
    case Country = 5
    case StateOrProvince = 6
    case Timezone = 7
    case AddressLine1 = 8
    case AddressLine2 = 9
    case City = 10
    case ZipOrPostalCode = 11
    case Phone = 12
    case MobilePhone = 13
    case Fax = 14
    case Website = 15
    case SkypeID = 16
    case BlackberryPIN = 17
    case HowDidYouHearAboutUs = 18
    case PromotionalCode = 19
    case DBDUNSNo = 20
    
    var title: String {
        switch self {
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

class RegisterAccountDetailsModel: NSObject {

}
