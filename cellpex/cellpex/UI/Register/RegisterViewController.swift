//
//  RegisterViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 14/12/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class EnterInfoRegistrationCell: UITableViewCell {
    @IBOutlet weak var titleInfoLabel: UILabel!
    @IBOutlet weak var addInfoTextField: UITextField!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    
}

class RegisterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let navigationTitleView = UIImageView.init(image: UIImage(named: "login_logo_image")!)
        if #available(iOS 11.0, *) {
            
        } else {
            navigationTitleView.frame = self.navigationController?.navigationBar.frame ?? CGRect.zero
        }
        navigationTitleView.contentMode = .scaleAspectFit
        navigationItem.titleView = navigationTitleView
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension RegisterViewController : UITableViewDelegate {
    
}

extension RegisterViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnterInfoRegistrationCell") as! EnterInfoRegistrationCell
        cell.titleInfoLabel.text = "TITLE"
        cell.addInfoTextField.text = "additional"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}
