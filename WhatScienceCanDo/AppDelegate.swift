//
//  AppDelegate.swift
//  WhatScienceCanDo
//
//  Created by Ahmed on 11/1/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit
import UserNotificationsUI
import IQKeyboardManagerSwift
import OneSignal
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , OSSubscriptionObserver {
  
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
  
    
    var window: UIWindow?
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace '11111111-2222-3333-4444-0123456789ab' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "7db21182-70e0-4502-b783-c6aa5bcb2aa2",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            
            print("User accepted notifications: \(accepted)")
        })
        OneSignal.add(self as OSSubscriptionObserver)
        if let option = launchOptions {
            let info = option[UIApplicationLaunchOptionsKey.remoteNotification]
            if (info != nil) {
            }}
        
        return true
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            ApiToken.SetItems(Key: "OneSignalToken", Value: "\(playerId)")
            
        }
    }
    

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        SocketIOManager.sharedInstance.establishConnection()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        SocketIOManager.sharedInstance.closeConnection()
    }

    
}

extension AppDelegate  {
    
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
        
     
    }
    
}

