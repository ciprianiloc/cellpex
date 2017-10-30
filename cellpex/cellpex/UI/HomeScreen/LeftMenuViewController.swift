//
//  LeftMenuViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case Home = 0
    case FollowingInventory
    case Messages
    case Feedback
    case LogOut
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuViewController: UIViewController, LeftMenuProtocol {

    @IBOutlet weak var tableView: UITableView!
    var menus = ["Home", "Following Inventory", "Messages", "Feedback", "Log Out"]
    var mainViewController: UIViewController!
    var swiftViewController: UIViewController!
    var javaViewController: UIViewController!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
    }
}

extension LeftMenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell") as! LeftMenuCell
        cell.menuLabel.text = menus[indexPath.row]
        return cell
    }
}

extension LeftMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .Home:
                self.slideMenuController()?.closeLeft()
            case .Messages :
                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let messagesViewController = homeStoryboard.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
                self.slideMenuController()?.navigationController?.pushViewController(messagesViewController, animated: true)
            case .Feedback :
                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let feedbackViewController = homeStoryboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
                self.slideMenuController()?.navigationController?.pushViewController(feedbackViewController, animated: true)
            case .FollowingInventory :
                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let followingInventoryViewController = homeStoryboard.instantiateViewController(withIdentifier: "FollowingInventoryViewController") as! FollowingInventoryViewController
                self.slideMenuController()?.navigationController?.pushViewController(followingInventoryViewController, animated: true)
            case .LogOut :
                self.slideMenuController()?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

