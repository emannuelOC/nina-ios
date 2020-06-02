//
//  AppDelegate.swift
//  Nina
//
//  Created by Emannuel Carvalho on 13/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let log = Nina.log(for: AppDelegate.self)
        
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error != nil {
                os_log(.error, log: self.log, "Failed request user notification authorization at: %{PUBLIC}@", "\(#function)")
            } else if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Nina")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                os_log("Failed to load the persistent store", log: self.log, type: .error, #function)
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                os_log("Failed to save the context", log: self.log, type: .error, #function)
            }
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let subscription = CKQuerySubscription(recordType: "Notifications",
                                               predicate: NSPredicate(format: "TRUEPREDICATE"),
                                               options: .firesOnRecordCreation)
        
        let info = CKSubscription.NotificationInfo()
        info.titleLocalizationKey = "%1$@"
        info.titleLocalizationArgs = ["title"]
        info.alertLocalizationKey = "%1$@"
        info.alertLocalizationArgs = ["content"]
        info.soundName = "default"
        
        subscription.notificationInfo = info
        
        CKContainer(identifier: "iCloud.Nina").publicCloudDatabase.save(subscription, completionHandler: { _, error in
            if error != nil {
                os_log("Failed to subscribe to notifications", log: self.log, type: .error, #function)
            }
        })
        
    }


}

