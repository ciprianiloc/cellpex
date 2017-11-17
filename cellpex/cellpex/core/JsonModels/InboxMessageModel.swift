//
//  InboxMessageModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 08/11/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

public enum ServerInboxMessageModel: String {
    case id = "id"
    case senderId = "senderId"
    case user = "user"
    case userLevel = "userLevel"
    case system = "system"
    case subject = "subject"
    case message = "message"
    case viewed = "viewed"
    case date = "date"
    case replied = "replied"
}

struct InboxMessageModel {
    private(set) var isValidProduct = true
    var subject : String?
    var message : String?
    var id : String?
    var date : String?
    var viewed : String?
    var senderId : String?
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
        subject = messageDictionary[ServerInboxMessageModel.subject.rawValue] as? String
        message = messageDictionary[ServerInboxMessageModel.message.rawValue] as? String
        id = messageDictionary[ServerInboxMessageModel.id.rawValue] as? String
        date = messageDictionary[ServerInboxMessageModel.date.rawValue] as? String
        senderId = messageDictionary[ServerInboxMessageModel.senderId.rawValue] as? String
        system = messageDictionary[ServerInboxMessageModel.system.rawValue] as? String
        userLevel = messageDictionary[ServerInboxMessageModel.userLevel.rawValue] as? String
        user = messageDictionary[ServerInboxMessageModel.user.rawValue] as? String
        viewed = messageDictionary[ServerInboxMessageModel.viewed.rawValue] as? String
        replied = messageDictionary[ServerInboxMessageModel.replied.rawValue] as? String
    }
}
