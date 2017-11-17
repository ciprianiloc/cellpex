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
