//
//  AppDelegate.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Realm
        print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
            _ = try Realm()
        } catch {
            print("error initialising realm: \(error)")
        }
        
        
        
        //Notification Authorization
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .sound)
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Notification error:\(error)")
            }
        }
        
        // App Appearence
        UINavigationBar.appearance().backgroundColor = .yellow
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        
        UITabBar.appearance().backgroundColor = .yellow
        UITabBar.appearance().tintColor = .systemRed

        return true
        
        
    }

    
        
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
//    
//    func applicationWillTerminate(_ application: UIApplication) {
//        <#code#>
//    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

