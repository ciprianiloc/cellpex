//
//  SentMessageModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/17/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

public enum ServerSentMessageModel: String {
    case id = "id"
    case receiverId = "receiverId"
    case user = "user"
    case userLevel = "userLevel"
    case system = "system"
    case subject = "subject"
    case message = "message"
    case viewed = "viewed"
    case date = "date"
    case replied = "replied"
}

/*
▿ some : 10 elements
▿ 0 : 2 elements
- key : "subject"
▿ value : Optional<Any>
- some : General Availability on WTS: Apple iPhone 4 | Other | 75.00 USD
▿ 1 : 2 elements
- key : "replied"
▿ value : Optional<Any>
- some : no
▿ 2 : 2 elements
- key : "user"
▿ value : Optional<Any>
- some : ionut
▿ 3 : 2 elements
- key : "id"
▿ value : Optional<Any>
- some : 569
▿ 4 : 2 elements
- key : "date"
▿ value : Optional<Any>
- some : 16 Nov
▿ 5 : 2 elements
- key : "receiverId"
▿ value : Optional<Any>
- some : 54
▿ 6 : 2 elements
- key : "message"
▿ value : Optional<Any>
- some : <b>Item : </b> <a href="/cell-phones-wholesale/333/phones-tablets-wholesale-suppliers/wholesale">WTS: Apple iPhone 4 | Other | 75.00 USD</a><br /><br /><br /><br />Test
▿ 7 : 2 elements
- key : "system"
▿ value : Optional<Any>
- some : 0
▿ 8 : 2 elements
- key : "userLevel"
▿ value : Optional<Any>
- some : 2
▿ 9 : 2 elements
- key : "viewed"
▿ value : Optional<Any>
- some : no
*/
struct SentMessageModel {
    private(set) var isValidProduct = true
    var subject : String?
    var message : String?
    var id : String?
    var date : String?
    var viewed : String?
    var receiverId : String?
    var system : String?
    var userLevel : String?
    var user : String?
    var replied : String?
    
    init(dictionary: [String: Any?]?) {
        guard let messageDictionary = dictionary else {
            isValidProduct = false
            return;
        }
        isValidProduct = true
        subject = messageDictionary[ServerSentMessageModel.subject.rawValue] as? String
        message = messageDictionary[ServerSentMessageModel.message.rawValue] as? String
        id = messageDictionary[ServerSentMessageModel.id.rawValue] as? String
        date = messageDictionary[ServerSentMessageModel.date.rawValue] as? String
        receiverId = messageDictionary[ServerSentMessageModel.receiverId.rawValue] as? String
        system = messageDictionary[ServerSentMessageModel.system.rawValue] as? String
        userLevel = messageDictionary[ServerSentMessageModel.userLevel.rawValue] as? String
        user = messageDictionary[ServerSentMessageModel.user.rawValue] as? String
        viewed = messageDictionary[ServerSentMessageModel.viewed.rawValue] as? String
        replied = messageDictionary[ServerSentMessageModel.replied.rawValue] as? String
    }
}
