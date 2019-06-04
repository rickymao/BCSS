//
//  AppDelegate.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-12.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
   
        unowned let userdefaults = UserDefaults.standard
        unowned let persistenceManager = PersistenceManager.shared
        let notificationDelegate = NotificationDelegate()
        
        
        
        if userdefaults.value(forKey: "isFirstLaunch") != nil {
            
            print("Not First Launch")
            
        } else {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in
                
            }

            
            let dateFormat = DateFormatter()
            let events = Event.eventsList
            
            for event in events {
                if event.title == "Collaboration Day" {
                    
                    //Content
                    let notification = UNMutableNotificationContent()
                    notification.title = "Collaboration Day Tomorrow"
                    notification.body = "Make sure to bring some assignments to work on!"
                    notification.badge = 1
                    notification.sound = UNNotificationSound.default
                    
                    //Day before notification
                    let calendar = Calendar.current
                    dateFormat.dateFormat = "yyyy/MM/dd"
                    
                    if let date = dateFormat.date(from: event.date) {
                        let collab = calendar.date(byAdding: .day, value: -1, to: date)
                        var dateComponent = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: collab!)
                        dateComponent.hour = 20
                        
                        //trigger
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                        
                        //Request notifications
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { (Error) in
                            
                            if let error = Error {
                                print(error)
                            }
                            
                        }
                        
                    }
                    
                    
                }
              
                
                
            }
           
            
            
            
            
            //Setup schedule
            let blockXsem1 = Blocks(context: persistenceManager.context)
            blockXsem1.blockX = true
            blockXsem1.block = 0
            blockXsem1.semester = 1
            
            let block1sem1 = Blocks(context: persistenceManager.context)
            block1sem1.block = 1
            block1sem1.semester = 1
  
            let block2sem1 = Blocks(context: persistenceManager.context)
            block2sem1.block = 2
            block2sem1.semester = 1
            
            let block3sem1 = Blocks(context: persistenceManager.context)
            block3sem1.block = 3
            block3sem1.semester = 1
            
            let block4sem1 = Blocks(context: persistenceManager.context)
            block4sem1.block = 4
            block4sem1.semester = 1
            
            let blockXsem2 = Blocks(context: persistenceManager.context)
            blockXsem2.blockX = true
            blockXsem2.block = 0
            blockXsem2.semester = 2
            
            let block1sem2 = Blocks(context: persistenceManager.context)
            block1sem2.block = 1
            block1sem2.semester = 2
            
            let block2sem2 = Blocks(context: persistenceManager.context)
            block2sem2.block = 2
            block2sem2.semester = 2
            
            let block3sem2 = Blocks(context: persistenceManager.context)
            block3sem2.block = 3
            block3sem2.semester = 2
            
            let block4sem2 = Blocks(context: persistenceManager.context)
            block4sem2.block = 4
            block4sem2.semester = 2
            
            
            
            persistenceManager.save()
             print("First Launch")
            
            userdefaults.set(true, forKey: "isFirstLaunch")
 
        }
        
        
        
        //Temporary feature
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().delegate = notificationDelegate
        
    
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
        
        //Temporary feature
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }



}

