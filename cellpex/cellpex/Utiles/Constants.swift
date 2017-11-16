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
    static let redirectURL = "https://www.cellpex.com/index.php?fuseaction=site.device_redirect"
    static let noLogoURL = "https://www.cellpex.com/assets/images/no_company_logo.jpeg"
}

struct WebServices {
    static let productionHostName = "https://www.cellpex.com/"
    static let devHostName = "https://dev.cellpex.com/"
    static let apiToUse = "XXXapi/v1/"
    static let wsLogin = "login.php"
    static let wsLogout = "logout.php"
    static let wsUpdateDevice = "update_device.php"
    static let getProduct = "get_posts.php"
    static let getFollowingMemebers = "get_posts_following_members.php"
    static let getProductsSearch = "get_posts_search.php"

    static let getProductDetails = "get_post_details.php"
    static let getUnreadMessageCounter = "get_unread_messages_inbox.php"
}

struct KeychainConstant {
    static let deviceID = "device id"
    static let username = "username"
    static let password = "password"
    static let userID   = "user id"
}

struct UtilsConstant {
    static let UserIsLogIn = "UserIsLogIn"
}
