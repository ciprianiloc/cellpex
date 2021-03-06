//
//  LeftMenuModel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case Home = 0
    case FollowingInventory
    case Messages
    case Feedback
    case LogOut
}


struct LeftMenuModel {
    
    static let numberOfEntriesInMenu = 5
    
    var title = ""
    var icon : UIImage?
    let menuOption : LeftMenu!
    let hasMessageCounter : Bool!
    init(leftMenu: LeftMenu) {
        menuOption = leftMenu;
        switch leftMenu {
        case .Home :
            title = "Home"
            icon = UIImage.init(named: "home_icon")
            hasMessageCounter = false
        case .FollowingInventory :
            title = "Following Inventory"
            icon = UIImage.init(named: "followingInventory_icon")
            hasMessageCounter = false
        case .Messages :
            title = "Messages"
            icon = UIImage.init(named: "messages_icon")
            hasMessageCounter = true
        case .Feedback :
            title = "Feedback"
            icon = UIImage.init(named: "feedback_icon")
            hasMessageCounter = false
        case .LogOut :
            title = "Log Out"
            icon = UIImage.init(named: "logout_icon")
            hasMessageCounter = false

    }
}
}
