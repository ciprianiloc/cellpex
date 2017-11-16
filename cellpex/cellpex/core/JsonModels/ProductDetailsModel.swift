//
//  ProductDetailsModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 15/11/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

public enum ServerProductDetailsModel: String {
    case cond = "cond"
    case date = "date"
    case id = "id"
    case imageUrl = "imageUrl"
    case name = "name"
    case price = "price"
    case user = "user"
    case userId = "userId"
    case userLevel = "userLevel"
    case availability = "availability"
    case carrier = "carrier"
    case color = "color"
    case country = "country"
    case details = "details"
    case imagesUrl = "imagesUrl"
    case market = "market"
    case memory = "memory"
    case minQuantity = "minQuantity"
    case pack = "pack"
    case shipp = "shipp"
    case simStatus = "simStatus"
    case state = "state"
    case userCompany = "userCompany"
    case userCompanyLogoUrl = "userCompanyLogoUrl"
    case userCountry = "userCountry"
    case userFeedbackScore = "userFeedbackScore"
    case userState = "userState"
    case quantity = "quantity"
}


struct ProductDetailsModel {
    var isValidProduct = false
    
    var cond : String?
    var date : String?
    var id : String?
    var imageUrl : String?
    var name : String?
    var price : String?
    var user : String?
    var userId : String?
    var userLevel : String?
    var availability : String?
    var carrier : String?
    var color : String?
    var country : String?
    var details : String?
    var imagesUrl : [String?]?
    var market : String?
    var memory : String?
    var minQuantity : String?
    var pack : String?
    var shipp : String?
    var simStatus : String?
    var state : String?
    var userCompany : String?
    var userCompanyLogoUrl : String?
    var userCountry : String?
    var userFeedbackScore : String?
    var userState : String?
    var quantity : String?
    
    var condition : String?
    var providerAddress : String?
    var carrierAndSimStatus : String?
    init(dictionary: [String: Any?]?) {
        guard let productDetails = dictionary else {
            isValidProduct = false
            return;
        }
        isValidProduct = true
        cond = productDetails[ServerProductDetailsModel.cond.rawValue] as? String
        date = productDetails[ServerProductDetailsModel.date.rawValue] as? String
        id = productDetails[ServerProductDetailsModel.id.rawValue] as? String
        imageUrl = productDetails[ServerProductDetailsModel.imageUrl.rawValue] as? String
        name = productDetails[ServerProductDetailsModel.name.rawValue] as? String
        price = productDetails[ServerProductDetailsModel.price.rawValue] as? String
        user = productDetails[ServerProductDetailsModel.user.rawValue] as? String
        userId = productDetails[ServerProductDetailsModel.userId.rawValue] as? String
        userLevel = productDetails[ServerProductDetailsModel.userLevel.rawValue] as? String
        availability = productDetails[ServerProductDetailsModel.availability.rawValue] as? String
        carrier = productDetails[ServerProductDetailsModel.carrier.rawValue] as? String
        color = productDetails[ServerProductDetailsModel.color.rawValue] as? String
        country = productDetails[ServerProductDetailsModel.country.rawValue] as? String
        details = productDetails[ServerProductDetailsModel.details.rawValue] as? String
        imagesUrl = productDetails[ServerProductDetailsModel.imagesUrl.rawValue] as? [String?]
        market = productDetails[ServerProductDetailsModel.market.rawValue] as? String
        memory = productDetails[ServerProductDetailsModel.memory.rawValue] as? String
        minQuantity = productDetails[ServerProductDetailsModel.minQuantity.rawValue] as? String
        pack = productDetails[ServerProductDetailsModel.pack.rawValue] as? String
        shipp = productDetails[ServerProductDetailsModel.shipp.rawValue] as? String
        simStatus = productDetails[ServerProductDetailsModel.simStatus.rawValue] as? String
        state = productDetails[ServerProductDetailsModel.state.rawValue] as? String
        userCompany = productDetails[ServerProductDetailsModel.userCompany.rawValue] as? String
        userCompanyLogoUrl = productDetails[ServerProductDetailsModel.userCompanyLogoUrl.rawValue] as? String
        userCountry = productDetails[ServerProductDetailsModel.userCountry.rawValue] as? String
        userFeedbackScore = productDetails[ServerProductDetailsModel.userFeedbackScore.rawValue] as? String
        userState = productDetails[ServerProductDetailsModel.userState.rawValue] as? String
        quantity = productDetails[ServerProductDetailsModel.quantity.rawValue] as? String
       
        if let condValue = cond, condValue.count > 0 {
            condition = condValue
            if let memoryValue = memory, memoryValue.count > 0 {
                condition = "\(condValue) | \(memoryValue)"
                if let colorValue = color, colorValue.count > 0 {
                    condition = "\(condValue) | \(memoryValue) | \(colorValue)"
                }
            } else {
                if let colorValue = color, colorValue.count > 0 {
                    condition = "\(condValue) | \(colorValue)"
                }
            }
        } else {
            if let memoryValue = memory, memoryValue.count > 0 {
                condition = memoryValue
                if let colorValue = color, colorValue.count > 0 {
                    condition = "\(memoryValue) | \(colorValue)"
                }
            } else {
                if let colorValue = color, colorValue.count > 0 {
                    condition = colorValue
                }
            }
        }
        if let userCountryValue = userCountry, userCountryValue.count > 0 {
            providerAddress = userCountryValue
            if let userStateValue = userState, userStateValue.count > 0 {
                providerAddress = "\(userCountryValue), \(userStateValue)"
            }
        } else {
            if let userStateValue = userState, userStateValue.count > 0 {
                providerAddress = userStateValue
            }
        }
        if let carrierValue = carrier, carrierValue.count > 0 {
            carrierAndSimStatus = carrierValue
            if let simStatusValue = simStatus, simStatusValue.count > 0 {
                carrierAndSimStatus = "\(carrierValue) | \(simStatusValue)"
            }
        } else {
            if let simStatusValue = simStatus, simStatusValue.count > 0 {
                carrierAndSimStatus = simStatusValue
            }
        }

        
    }
}
