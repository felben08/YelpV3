//
//  AppDelegate.swift
//  Yelp Felben
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func setupRootVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let businessesNavCtrl = storyboard.instantiateViewController(withIdentifier: "businessesNavCtrl") as! UINavigationController
        let containerVC = businessesNavCtrl.topViewController as! BusinessesContainerVC
        
        let tableVC = storyboard.instantiateViewController(withIdentifier: "businessTBVC") as! BusinessesTableVC
        let mapVC = storyboard.instantiateViewController(withIdentifier: "businessMapVC") as! BusinessesMapVC
        
        containerVC.mapViewController = mapVC
        containerVC.tableViewController = tableVC
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = businessesNavCtrl
        window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupRootVC()
        
        YelpClient.sharedInstance.configure()
        
        return true
    }

}

