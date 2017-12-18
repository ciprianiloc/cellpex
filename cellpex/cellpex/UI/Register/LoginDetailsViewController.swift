//
//  LoginDetailsViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 18/12/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class LoginDetailsViewController: RegisterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login Details"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension LoginDetailsViewController : UITableViewDelegate {
    
}

extension LoginDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegisterLoginDetailsField.EmailAddressAgain.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnterInfoRegistrationCell") as! EnterInfoRegistrationCell
        let registrationField = RegisterLoginDetailsField(rawValue: indexPath.row)
        cell.titleInfoLabel.text = registrationField?.title
        cell.additionalInfoLabel.text = registrationField?.additionalInfo
        cell.titleInfoLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
 
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let registrationField = RegisterLoginDetailsField(rawValue: indexPath.row)
        if let additionalInfo = registrationField?.additionalInfo, additionalInfo.count > 0 {
            return  107
        }
        return 70
    }
}
