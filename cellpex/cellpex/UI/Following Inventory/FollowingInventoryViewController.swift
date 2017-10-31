//
//  FollowingInventoryViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class FollowingInventoryViewController: ListOfProductsViewController {
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterLabel.text = "Following Inv"
        unreadMessagesLabel.text = "Unread messages 8"
    }    

}
