//
//  AppDelegate.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func customizeAppearance() {
        window?.tintColor = kSystemTintColor
        
        UINavigationBar.appearance().isTranslucent = false

        let shadow = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        shadow.backgroundColor = kSystemSeparatorColor
        let shadowImg = Utils.imageFromView(shadow)
        UINavigationBar.appearance().shadowImage = shadowImg
        
        let navBarBg = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        let navBarBgImage = Utils.imageFromView(navBarBg)
        UINavigationBar.appearance().setBackgroundImage(navBarBgImage, for: .default)
        
        let tabbarShadow = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        tabbarShadow.backgroundColor = kSystemSeparatorColor
        let tabbarShadowImg = Utils.imageFromView(tabbarShadow)
        UITabBar.appearance().shadowImage = tabbarShadowImg
        
        let tabBarBg = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        let tabBarBgImage = Utils.imageFromView(tabBarBg)
        UITabBar.appearance().backgroundImage = tabBarBgImage
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

