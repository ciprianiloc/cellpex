//
//  SentMessagesModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/17/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

public enum ServerSentMessagesModel: String {
    case id = "id"
    case receiverId = "receiverId"
    case user = "user"
    case userLevel = "userLevel"
    case system = "system"
    case subject = "subject"
    case shortMessage = "shortMessage"
    case viewed = "viewed"
    case date = "date"
    case replied = "replied"
}

struct SentMessagesModel {
    private(set) var isValidProduct = true
    var subject : String?
    var shortMessage : String?
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
        subject = messageDictionary[ServerSentMessagesModel.subject.rawValue] as? String
        shortMessage = messageDictionary[ServerSentMessagesModel.shortMessage.rawValue] as? String
        id = messageDictionary[ServerSentMessagesModel.id.rawValue] as? String
        date = messageDictionary[ServerSentMessagesModel.date.rawValue] as? String
        receiverId = messageDictionary[ServerSentMessagesModel.receiverId.rawValue] as? String
        system = messageDictionary[ServerSentMessagesModel.system.rawValue] as? String
        userLevel = messageDictionary[ServerSentMessagesModel.userLevel.rawValue] as? String
        user = messageDictionary[ServerSentMessagesModel.user.rawValue] as? String
        viewed = messageDictionary[ServerSentMessagesModel.viewed.rawValue] as? String
        replied = messageDictionary[ServerSentMessagesModel.replied.rawValue] as? String
    }
}
