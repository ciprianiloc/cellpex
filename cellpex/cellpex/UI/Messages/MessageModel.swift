//
//  MessageModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 08/11/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

//["error"] = "0"
//["data"]["id"] = "7253"
//["data"]["senderId"] = "60994"
//["data"]["user"] = "ionut"
//["data"]["userLevel"] = "2"
//["data"]["system"] = "0"
//["data"]["subject"] = "subject"
//["data"]["message"] = "message"
//["data"]["viewed"] = "1"
//["data"]["date"] = "d, M Y"
struct Message {
    var subject : String
    var message : String
    var from : String
    var date : Date
    var isViewed : Bool
    var isFromSystem : Bool
    var userLevel : Int
    
}
