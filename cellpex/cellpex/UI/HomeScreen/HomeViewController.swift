//
//  HomeViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 10/27/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class HomeViewController: ListOfProductsViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    
    override var productCollectionView :UICollectionView? {
        return collectionView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addLeftBarButtonWithImage(UIImage(named: "hamburger_icon")!)
        filterLabel.text = "Wholesale Lots"
        unreadMessagesLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.unreadMessagesLabelTap))
        unreadMessagesLabel.addGestureRecognizer(gesture)
        self.unreadMessagesLabel.text = "Messages"
        NetworkManager.getUnreadMessageCount { [weak self](numberOfMessage:Int) in
            if numberOfMessage > 0 {
                DispatchQueue.main.async {
                    self?.unreadMessagesLabel.text = "Unread messages \(numberOfMessage)"
                }
            }
        }
        self.productManager.requestFirstTimeProducts { [weak self] in
            self?.productsReceived()
        }
    }
    
    @objc func unreadMessagesLabelTap() {
        self.performSegue(withIdentifier: "showMessages", sender: self)
    }
    
}


extension HomeViewController: SlideMenuControllerDelegate {

}

