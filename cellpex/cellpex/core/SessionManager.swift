//
//  SessionManager.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/14/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Reachability

final class SessionManager: NSObject {
    
    static let manager = SessionManager()
    var userModel : UserModel?
    let reachability = Reachability()

    override private init() {
        super.init()
    }
    
    func loadUserModel(dictinary : [String : Any?]?) ->Bool {
        userModel = UserModel(dictionary: dictinary)
        guard let _ = userModel?.id, let _ = userModel?.user, let _ = userModel?.email, let _ =
            userModel?.id else {
                return false
        }
        return true
    }
    
}
