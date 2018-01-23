//
//  AppDelegate.swift
//  TableTest
//
//  Created by AlveenaFalaq on 1/3/18.
//  Copyright © 2018 AlveenaFalaq. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Realm file reference
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
            
        } catch {
            print ("error initialising new realm \(error)")
        }
        return true
    }

}
