//
//  AppDelegate.swift
//  virtual tourist
//
//  Created by Abdualrahman on 6/16/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataController.sharedInstance.load()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
         self.saveContext()
    }


    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

        func saveContext () {
            
            try? DataController.sharedInstance.viewContext.save()
    }

}

