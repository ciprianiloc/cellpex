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
    
    init(leftMenu: LeftMenu) {
        switch leftMenu {
        case .Home :
            title = "Home"
            icon = UIImage.init(named: "home_icon")
        case .FollowingInventory :
            title = "Following Inventory"
            icon = UIImage.init(named: "followingInventory_icon")
        case .Messages :
            title = "Messages"
            icon = UIImage.init(named: "messages_icon")
        case .Feedback :
            title = "Feedback"
            icon = UIImage.init(named: "feedback_icon")
        case .LogOut :
            title = "Log Out"
            icon = UIImage.init(named: "logout_icon")
    }
}
}
