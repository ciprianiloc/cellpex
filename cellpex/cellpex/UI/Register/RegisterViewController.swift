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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
