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

    @IBOutlet weak var passwordTextField: PaddedTextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    let passwordTextFieldRightButton = UIButton(type: .custom)
    var passwordTextFieldShoulBeSecure = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotButton.layer.borderWidth = 1.0
        forgotButton.layer.borderColor = UIColor.lightGray.cgColor
        registerButton.backgroundColor = UIColor(named: "button_enable_color")
        passwordTextField.rightViewMode = .always
        updateLoginButtonState()
        
        passwordTextFieldRightButton.frame =  CGRect(x: 0, y: 0, width: passwordTextField.frame.height - 12, height: passwordTextField.frame.height - 12)
        passwordTextFieldRightButton.contentMode = UIViewContentMode.center
        passwordTextField.rightView = passwordTextFieldRightButton
        passwordTextFieldRightButton.addTarget(self, action: #selector(self.passwordTextFieldRightButtonAction), for: .touchUpInside)
        let passwordTextFieldRightButtonImage = passwordTextFieldShoulBeSecure ? "eyes_icon_secure" : "eyes_icon_notsecure"
        passwordTextFieldRightButton.setImage(UIImage(named: passwordTextFieldRightButtonImage), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLoginButtonState), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        passwordTextField.isSecureTextEntry = passwordTextFieldShoulBeSecure
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
        UserDefaults.standard.set(usernameTextField.text, forKey: UtilsConstant.UserIsLogIn)
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
    
    @objc fileprivate func passwordTextFieldRightButtonAction() {
        passwordTextFieldShoulBeSecure = (!passwordTextFieldShoulBeSecure)
        let passwordTextFieldRightButtonImage = passwordTextFieldShoulBeSecure ? "eyes_icon_secure" : "eyes_icon_notsecure"
        passwordTextFieldRightButton.setImage(UIImage(named: passwordTextFieldRightButtonImage), for: .normal)
        passwordTextField.isSecureTextEntry = passwordTextFieldShoulBeSecure
    }
}

extension LoginViewController : UITextFieldDelegate {

}
