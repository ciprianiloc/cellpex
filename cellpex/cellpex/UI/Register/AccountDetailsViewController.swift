//
//  AccountDetailsViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 18/12/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class AccountDetailsViewController: RegisterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Account Details"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension AccountDetailsViewController : UITableViewDelegate {
    
}

extension AccountDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RegistrationAccountDetailsField.DBDUNSNo.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnterInfoRegistrationCell") as! EnterInfoRegistrationCell
        let registrationField = RegistrationAccountDetailsField(rawValue: indexPath.row)
        cell.titleInfoLabel.text = registrationField?.title
        cell.additionalInfoLabel.text = registrationField?.additionalInfo
        if let isMandatory = registrationField?.isMandatoryForBayer, isMandatory{
            cell.titleInfoLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        } else {
            cell.titleInfoLabel.font = UIFont.systemFont(ofSize: 17.0)
        }
        if let isPhoneFormat = registrationField?.isPhoneFormat, isPhoneFormat {
            let leftButton = UIButton.init(type: .custom)
            leftButton.frame = CGRect.init(x: 0, y: 0, width: 60, height: cell.addInfoTextField.frame.size.height)
            leftButton.titleLabel?.font = cell.addInfoTextField.font
            leftButton.setTitle("+1", for: .normal)
            leftButton.setTitleColor(.black, for: .normal)
            leftButton.layer.borderWidth = 1.0
            leftButton.layer.borderColor = UIColor.black.cgColor
            leftButton.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            cell.addInfoTextField.leftViewMode = .always
            cell.addInfoTextField.leftView = leftButton
        } else {
            cell.addInfoTextField.leftViewMode = .never
            cell.addInfoTextField.leftView = nil
        }
        if let isListFormat = registrationField?.isListFormat, isListFormat {
            let image = UIImageView.init(image: UIImage.init(named: "selection_arrow_icon"))
            image.frame = CGRect.init(x: 0, y: 0, width: 30, height: 20)
            image.contentMode = .scaleAspectFit
            cell.addInfoTextField.rightView = image
            cell.addInfoTextField.rightViewMode = .always
        } else {
            cell.addInfoTextField.rightViewMode = .never
            cell.addInfoTextField.rightView = nil
        }


        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let registrationField = RegistrationAccountDetailsField(rawValue: indexPath.row)
        if let additionalInfo = registrationField?.additionalInfo, additionalInfo.count > 0 {
            return  107
        }
        return 70
    }
}
