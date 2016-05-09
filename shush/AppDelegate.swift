//
//  AppDelegate.swift
//  shush
//
//  Created by Adrian Vatchinsky on 4/28/16.
//  Copyright © 2016 Adrian Vatchinsky. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var toggleDND = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // ref: https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html
        
        // create an action
        let acceptAction = UIMutableUserNotificationAction()
        // The identifier that you use internally to handle the action.
        acceptAction.identifier = "TOGGLE_DND"
        // The localized title of the action button.
        acceptAction.title = "Do Not Disturb"
        // Specifies whether the app must be in the foreground to perform the action.
        acceptAction.activationMode = UIUserNotificationActivationMode.Background
        acceptAction.authenticationRequired = true
        acceptAction.destructive = false
        
        
        // create a category
        let inviteCategory = UIMutableUserNotificationCategory()
        // Identifier to include in your push payload and local notification
        inviteCategory.identifier = "BEACON_MONITORING"
        // Set the actions to display
        inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Default)
        inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Minimal)
        
        // registering notifications and categories
        let categories: Set = Set([inviteCategory])
        
        
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge],
                categories: categories
            )
        )
        
//        if(application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:)))) {
//            application.registerUserNotificationSettings(
//                UIUserNotificationSettings(
//                    forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge],
//                    categories: categories
//                )
//            )
//        }
//        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("[applicationDidBecomeActive] toggleDND is")
        print(toggleDND)
        
        if toggleDND {
            toggleDND = false
            UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=DO_NOT_DISTURB")!)
        }
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("got notfication")
        print(notification.userInfo!["TOGGLE_DND"])
        
        toggleDND = notification.userInfo!["TOGGLE_DND"] as! Bool
        
    }
    

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        print("handleActionWithIdentifier: \(identifier)")
        
//        print("The identifier is")
//        print(identifier)
//        
//        if(identifier == "TOGGLE_DND"){
//
//        }
        completionHandler()
    }
    

}

