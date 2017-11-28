//
//  AppDelegate.swift
//  cellpex
//
//  Created by Ciprian Iloc on 27/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        if (KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID) == nil) {
            KeychainWrapper.standard.set((UIDevice.current.identifierForVendor?.uuidString)!, forKey: KeychainConstant.deviceID)
        }
        
        Crashlytics.sharedInstance().setUserIdentifier(KeychainWrapper.standard.string(forKey: KeychainConstant.deviceID))
        
        let loadUserModelWithSuccess = SessionManager.manager.loadUserModel(dictinary: nil)
        if loadUserModelWithSuccess == false {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            return true
        }

        Crashlytics.sharedInstance().setUserName(SessionManager.manager.userModel?.id)
        Crashlytics.sharedInstance().setUserEmail(SessionManager.manager.userModel?.email)
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor.darkGray
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.delegate = mainViewController

        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

