//
//  LoginViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 27/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SafariServices
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: PaddedTextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    let passwordTextFieldRightButton = UIButton(type: .custom)
    var passwordTextFieldShoulBeSecure = true
    
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotButton.layer.borderWidth = 1.0
        forgotButton.layer.borderColor = UIColor.lightGray.cgColor
        registerButton.backgroundColor = UIColor.init(red: 25.0/255.0, green: 74.0/255.0, blue: 177.0/255.0, alpha: 1.0)
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
        self.loginSpinner.startAnimating()
        NetworkManager.loginWithUserName(username: usernameTextField.text!, password: passwordTextField.text!, successHandler: { [weak self] in
            DispatchQueue.main.async {
                self?.loginSpinner.stopAnimating()
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
                self?.navigationController?.pushViewController(slideMenuController, animated: true)
            }
        }) {[weak self](errorMessage: String) in
            DispatchQueue.main.async {
                self?.loginSpinner.stopAnimating()
                let alert = UIAlertController.init(title: nil, message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true)
            }
        }
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
        let loginButtonCollor = isLoginEnable ? UIColor.init(red: 25.0/255.0, green: 74.0/255.0, blue: 177.0/255.0, alpha: 1.0) : UIColor.init(white: 0.86, alpha: 1.0)
        self.loginButton.backgroundColor = loginButtonCollor
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
