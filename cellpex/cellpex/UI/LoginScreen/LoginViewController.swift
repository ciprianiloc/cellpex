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

    @IBOutlet weak var forgotButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotButton.layer.borderWidth = 1.0
        forgotButton.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view, typically from a nib.
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

