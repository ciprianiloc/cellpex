//
//  BaseViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 05/12/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = displayNoInternetConnectionAlertIfNeeded()
    }
    
    func displayNoInternetConnectionAlertIfNeeded() -> Bool {
        if let connection = SessionManager.manager.reachability?.connection, connection == .none {
            let alert = UIAlertController.init(title: "No Internet Connection", message: "Please check your connection. An internet connection is required so you can use this application.", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return true
        }
        return false
    }
}
