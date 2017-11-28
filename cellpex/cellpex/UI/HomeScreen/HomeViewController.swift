//
//  HomeViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 10/27/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
class HomeViewController: ListOfProductsViewController {
    private(set) var numberOfUnreadMessages = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addLeftBarButtonWithImage(UIImage(named: "hamburger_icon")!)
        filterLabel.text = "Wholesale Lots"
        valueForNoFilter = "Wholesale Lots"
        unreadMessagesLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.unreadMessagesLabelTap))
        unreadMessagesLabel.addGestureRecognizer(gesture)
        self.unreadMessagesLabel.text = ""
        self.productManager.requestFirstTimeProducts { [weak self] in
            self?.productsReceived()
        }
    }
    
    @objc func unreadMessagesLabelTap() {
        self.performSegue(withIdentifier: "showMessages", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.getUnreadMessageCount { [weak self](numberOfMessage:Int) in
            DispatchQueue.main.async {
                self?.numberOfUnreadMessages = numberOfMessage
                self?.unreadMessagesLabel.text = (numberOfMessage > 0) ? "Unread messages \(numberOfMessage)" : ""
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("HomeScreen", screenClass: "HomeViewController")
    }
    
}


extension HomeViewController: SlideMenuControllerDelegate {

}

