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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showMessageScreen), name: NSNotification.Name(rawValue: "shouldOpenMessage"), object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = displayNoInternetConnectionAlertIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "shouldOpenMessage"), object: nil)
        
    }
    
    @objc func showMessageScreen(withNotification:Notification) {
        let messageId = withNotification.object as? String
        if self.isKind(of: MessageViewController.classForCoder()) {
            let messageViewController = self as! MessageViewController
            messageViewController.beforeMessageIsLoad()
            messageViewController.requestInboxMessageDetails(mesageID: messageId)
        } else {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let messageViewController = storyboard.instantiateViewController(withIdentifier: "MessageViewController") as? MessageViewController {
                messageViewController.requestInboxMessageDetails(mesageID: messageId)
                self.navigationController?.pushViewController(messageViewController, animated: false)
            }
        }
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
