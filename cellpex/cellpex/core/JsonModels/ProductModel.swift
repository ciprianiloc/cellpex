//
//  ProductModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 15/11/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

public enum ServerProductModel: String {
    case cond = "cond"
    case date = "date"
    case id = "id"
    case imageUrl = "imageUrl"
    case name = "name"
    case nameExtra = "nameExtra"
    case price = "price"
    case user = "user"
    case userId = "userId"
    case userLevel = "userLevel"
}

struct ProductModel {
    var isValidProduct = false
    
    var cond : String?
    var date : String?
    var id : String?
    var imageUrl : String?
    var name : String?
    var nameExtra : String?
    var price : String?
    var user : String?
    var userId : String?
    var userLevel : String?
    
    init(dictionary: [String: Any?]?) {
        guard let productDictionary = dictionary else {
            isValidProduct = false
            return;
        }
        isValidProduct = true
        cond = productDictionary[ServerProductModel.cond.rawValue] as? String
        date = productDictionary[ServerProductModel.date.rawValue] as? String
        id = productDictionary[ServerProductModel.id.rawValue] as? String
        imageUrl = productDictionary[ServerProductModel.imageUrl.rawValue] as? String
        name = productDictionary[ServerProductModel.name.rawValue] as? String
        nameExtra = productDictionary[ServerProductModel.nameExtra.rawValue] as? String
        price = productDictionary[ServerProductModel.price.rawValue] as? String
        user = productDictionary[ServerProductModel.user.rawValue] as? String
        userId = productDictionary[ServerProductModel.userId.rawValue] as? String
        userLevel = productDictionary[ServerProductModel.userLevel.rawValue] as? String
    }
}
