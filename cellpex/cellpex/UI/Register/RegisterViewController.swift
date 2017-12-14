//
//  RegisterViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 14/12/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

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
