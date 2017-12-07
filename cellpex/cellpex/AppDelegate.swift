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
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
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
        let shouldPerformUpdate = UserDefaults.standard.object(forKey: UtilsConstant.shouldPerformUpdate) as? String
        let oldDeviceVersion = KeychainWrapper.standard.string(forKey: KeychainConstant.deviceOSVersion)
        let oldAppVersion = UserDefaults.standard.object(forKey: UtilsConstant.LastAppVersionKey) as? String
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: UtilsConstant.appVersionKey) as? String
        let shouldUpdate = UIDevice.current.systemVersion != oldDeviceVersion || shouldPerformUpdate == "YES" || currentVersion != oldAppVersion
        if  shouldUpdate {
            NetworkManager.updateDeviceInformation()
        }
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor.darkGray
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.delegate = mainViewController
        //TODO handle redirect to message if user opens the app by tapping on a PN message
//        if let messageViewController = storyboard.instantiateViewController(withIdentifier: "MessageViewController") as? MessageViewController {
//            let mesageModel = InboxMessagesModel.init(dictionary: nil)
//            messageViewController.requestInboxMessageDetails(mesageModel: mesageModel)
//            nvc.viewControllers.append(messageViewController)
//        }
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let oldFCMToken = KeychainWrapper.standard.string(forKey: KeychainConstant.fcmToken)
        KeychainWrapper.standard.set(fcmToken, forKey: KeychainConstant.fcmToken)
        if fcmToken != oldFCMToken {
            NetworkManager.updateDeviceInformation()
        }
        
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


