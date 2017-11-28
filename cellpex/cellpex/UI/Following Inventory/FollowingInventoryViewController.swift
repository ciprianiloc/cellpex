//
//  FollowingInventoryViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Firebase

class FollowingInventoryViewController: ListOfProductsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        filterLabel.text = "Following Inventory"
        valueForNoFilter = "Following Inventory"
        unreadMessagesLabel.text = ""
        unreadMessagesLabel.isHidden = true
        self.productManager.originalEndPoint = WebServices.getFollowingMemebers
        self.productManager.requestFirstTimeProducts { [weak self] in
            self?.productsReceived()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("FollowingInventoryScreen", screenClass: "FollowingInventoryViewController")
    }

}
