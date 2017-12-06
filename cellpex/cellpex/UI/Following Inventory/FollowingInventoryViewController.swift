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
    @IBOutlet weak var noElementsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterLabel.text = "Following Inventory"
        valueForNoFilter = "Following Inventory"
        unreadMessagesLabel.text = ""
        unreadMessagesLabel.isHidden = true
        self.productManager.originalEndPoint = WebServices.getFollowingMemebers
        self.productManager.requestFirstTimeProducts { [weak self] in
            let productCount = self?.productManager.products.count ?? 0
            self?.infoLabel(hiddenStatus: (productCount > 0))
            self?.productsReceived()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("FollowingInventoryScreen", screenClass: "FollowingInventoryViewController")
    }
    
    override func infoLabel(hiddenStatus: Bool) {
        DispatchQueue.main.async {[weak self] in
            self?.noElementsLabel.isHidden = hiddenStatus
        }
    }

}
