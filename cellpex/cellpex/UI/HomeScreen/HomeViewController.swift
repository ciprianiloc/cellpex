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
        filterLabel.text = "Wholesale Lots"
        unreadMessagesLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.unreadMessagesLabelTap))
        unreadMessagesLabel.addGestureRecognizer(gesture)
        self.unreadMessagesLabel.text = ""
        NetworkManager.getUnreadMessageCuont { [weak self](numberOfMessage:String) in
            self?.unreadMessagesLabel.text = "Unread messages \(numberOfMessage)"
        }
        NetworkManager.getProduct(search: nil, endPoint: WebServices.getProduct, successHandler: { [weak self](productsArray : [[String: Any?]?]?) in
            self?.loadProducts(productsArray: productsArray)
        }) { (errorMessage: String) in
            
        }
    }
    
    @objc func unreadMessagesLabelTap() {
        self.performSegue(withIdentifier: "showMessages", sender: self)
    }
    
}


extension HomeViewController: SlideMenuControllerDelegate {

}

