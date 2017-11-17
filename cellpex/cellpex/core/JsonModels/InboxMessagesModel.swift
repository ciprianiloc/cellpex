//
//  InboxMessagesModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/17/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

public enum ServerInboxMessagesModel: String {
    case id = "id"
    case senderId = "senderId"
    case user = "user"
    case userLevel = "userLevel"
    case system = "system"
    case subject = "subject"
    case shortMessage = "shortMessage"
    case viewed = "viewed"
    case date = "date"
    case replied = "replied"
}

struct InboxMessagesModel {
    private(set) var isValidProduct = true
    var subject : String?
    var shortMessage : String?
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
        subject = messageDictionary[ServerInboxMessagesModel.subject.rawValue] as? String
        shortMessage = messageDictionary[ServerInboxMessagesModel.shortMessage.rawValue] as? String
        id = messageDictionary[ServerInboxMessagesModel.id.rawValue] as? String
        date = messageDictionary[ServerInboxMessagesModel.date.rawValue] as? String
        senderId = messageDictionary[ServerInboxMessagesModel.senderId.rawValue] as? String
        system = messageDictionary[ServerInboxMessagesModel.system.rawValue] as? String
        userLevel = messageDictionary[ServerInboxMessagesModel.userLevel.rawValue] as? String
        user = messageDictionary[ServerInboxMessagesModel.user.rawValue] as? String
        viewed = messageDictionary[ServerInboxMessagesModel.viewed.rawValue] as? String
        replied = messageDictionary[ServerInboxMessagesModel.replied.rawValue] as? String
    }
}
