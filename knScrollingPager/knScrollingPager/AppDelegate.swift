//
//  AppDelegate.swift
//  knScrollingPager
//
//  Created by Ky Nguyen on 7/4/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupApp()
        return true
    }

    func setupApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = MainController()
        window!.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
    }

}

