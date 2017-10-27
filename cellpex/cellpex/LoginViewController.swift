//
//  LoginViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 27/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signInButtonAction(_ sender: Any) {
    }
    
    @IBAction func forgotButtonAction(_ sender: Any) {
        let forgotURL = "https://www.cellpex.com/index.php?fuseaction=site.forgot"
        if let url = URL(string: forgotURL) {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        let registerURL = "https://www.cellpex.com/index.php?fuseaction=site.register"
        if let url = URL(string: registerURL) {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
}

