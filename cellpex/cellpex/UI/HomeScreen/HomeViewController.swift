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
    
    let refreshControl = UIRefreshControl()
    override var productCollectionView :UICollectionView? {
        return collectionView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.addSubview(refreshControl)
        self.addLeftBarButtonWithImage(UIImage(named: "hamburger_icon")!)
        filterLabel.text = "Wholesale LotsWholesale LotsWholesale LotsWholesale Lots"
        unreadMessagesLabel.text = "Unread messages 8"
        unreadMessagesLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.unreadMessagesLabelTap))
        unreadMessagesLabel.addGestureRecognizer(gesture)
    }
    
    @objc func unreadMessagesLabelTap() {
        self.performSegue(withIdentifier: "showMessages", sender: self)
    }
    
}


extension HomeViewController: SlideMenuControllerDelegate {

}

