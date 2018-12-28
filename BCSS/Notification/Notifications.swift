//
//  Notifications.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-12-05.
//  Copyright © 2018 Treeline. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //plays sound
        completionHandler([.alert, .sound])
        
    }
    
}
