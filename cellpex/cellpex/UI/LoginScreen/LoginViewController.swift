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

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotButton.layer.borderWidth = 1.0
        forgotButton.layer.borderColor = UIColor.lightGray.cgColor
        registerButton.backgroundColor = UIColor(named: "button_enable_color")
        updateLoginButtonState()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLoginButtonState), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signInButtonAction(_ sender: Any) {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        let mainViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let leftViewController = homeStoryboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor.darkGray
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        if #available(iOS 11, *) {
        } else {
            slideMenuController.automaticallyAdjustsScrollViewInsets = true
        }
        slideMenuController.delegate = mainViewController as SlideMenuControllerDelegate
        self.navigationController?.pushViewController(slideMenuController, animated: true)

    }
    
    @IBAction func forgotButtonAction(_ sender: Any) {
        let forgotURL = URLConstant.forgotPassURL
        if let url = URL(string: forgotURL) {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        let registerURL = URLConstant.registrationURL
        if let url = URL(string: registerURL) {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    @objc private func updateLoginButtonState() {
        let isLoginEnable = (usernameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false)
        self.loginButton.isEnabled = isLoginEnable
        let loginButtonCollorName = isLoginEnable ? "button_enable_color" : "button_disabled_color"
        self.loginButton.backgroundColor = UIColor(named: loginButtonCollorName)
    }
}

extension LoginViewController : UITextFieldDelegate {

}
