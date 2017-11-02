//
//  LeftMenuViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuViewController: UIViewController, LeftMenuProtocol {

    @IBOutlet weak var userLogo: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
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
        userLabel.text = "user name (0)"
        companyLabel.text = "TestText"
        
        getDataFromUrl(url: URL(string: URLConstant.noLogoURL)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                guard let `self` = self else { return }
                self.userLogo.image = UIImage(data: data)
            }
        }
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
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}

extension LeftMenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LeftMenuModel.numberOfEntriesInMenu
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell") as! LeftMenuCell
        if let menu = LeftMenu(rawValue: indexPath.row) {
            let menuModel = LeftMenuModel(leftMenu: menu)
            cell.menuLabel.text = menuModel.title
            cell.menuIcon.image = menuModel.icon
            cell.messageCounterLabel.isHidden = (menuModel.hasMessageCounter == false)
            cell.messageCounterLabel.text = "26"
            return cell
        }
        return UITableViewCell()
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
                self.slideMenuController()?.closeLeft()
                let homeViewController = self.slideMenuController()?.delegate as! HomeViewController
                homeViewController.performSegue(withIdentifier: "showMessages", sender: self)
            case .Feedback :
                self.slideMenuController()?.closeLeft()
                let homeViewController = self.slideMenuController()?.delegate as! HomeViewController
                homeViewController.performSegue(withIdentifier: "showFeedback", sender: self)
            case .FollowingInventory :
                self.slideMenuController()?.closeLeft()
                let homeViewController = self.slideMenuController()?.delegate as! HomeViewController
                homeViewController.performSegue(withIdentifier: "showFollowingInventory", sender: self)
            case .LogOut :
                UserDefaults.standard.set(nil, forKey: UtilsConstant.UserIsLogIn)
                guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
                let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
                appDel.window?.rootViewController = rootController
            }
        }
    }
}

