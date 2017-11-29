//
//  Constants.swift
//  cellpex
//
//  Created by Ciprian Iloc on 10/31/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

typealias ButtonTappedAction = () -> ()

struct URLConstant {
    static let forgotPassURL = "https://www.cellpex.com/index.php?fuseaction=site.forgot"
    static let registrationURL = "https://www.cellpex.com/index.php?fuseaction=site.register"
    static let redirectURL = "\(WebServices.hostName)index.php?fuseaction=site.device_redirect"
    static let noLogoURL = "https://www.cellpex.com/assets/images/no_company_logo.jpeg"
}

struct WebServices {
    static let isForDevelopment = true
    static let productionHostName = "https://www.cellpex.com/"
    static let devHostName = "https://dev.cellpex.com/"
    static let apiToUse = "XXXapi/v1/"
    static let wsLogin = "login.php"
    static let wsLogout = "logout.php"
    static let wsUpdateDevice = "update_device.php"
    static let getProducts = "get_posts.php"
    static let getFollowingMemebers = "get_posts_following_members.php"
    static let getProductsSearch = "get_posts_search.php"
    static let getProductDetails = "get_post_details.php"
    static let getUnreadMessageCounter = "get_unread_messages_inbox.php"
    
    static let getInboxMessages = "get_messages_inbox.php"
    static let getInboxMessage = "get_message_inbox.php"
    static let getSendMessages = "get_messages_sent.php"
    static let getSendMessage = "get_message_sent.php"
    static let sendMessage = "post_message_send.php"
    static let sendReplyMessage = "post_message_reply.php"
    static let sendFeedbackMessage = "post_feedback_send.php"
    static let updateDevice = "update_device.php"
    static let hostName = isForDevelopment ? devHostName : productionHostName
}

struct KeychainConstant {
    static let deviceID = "device id"
    static let username = "username"
    static let password = "password"
    static let userID   = "user id"
    static let fcmToken = "fcmToken"
    static let deviceOSVersion = "deviceOSVersion"
}

struct UtilsConstant {
    static let UserIsLogIn = "UserIsLogIn"
}
