//
//  NotificationController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-11.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationController {
    
    init() { }
    
    func createNotification(title: String, body: String, date: String) {
             
              let dateFormat = DateFormatter()
                    
              //Content
              let notification = UNMutableNotificationContent()
              notification.title = title
              notification.body = body
              notification.badge = 0
              notification.sound = UNNotificationSound.default
              
              
              let calendar = Calendar.current
              dateFormat.dateFormat = "yyyy/MM/dd"
        
              //Flex Day notification setup
              if title.contains("Flex Time") {
                      
             if let flexDate = dateFormat.date(from: date) {
                
                          //Day before notification
                          let flex = calendar.date(byAdding: .day, value: -1, to: flexDate)
                          var dateComponent = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: flex!)
                          dateComponent.hour = 20
                          
                          //Trigger init
                          let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                          
                          //Request notifications
                          let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
                
                          //Add notification
                          UNUserNotificationCenter.current().add(request) { (Error) in
                              print("added")
                              if let error = Error {
                                  print(error)
                              }
                              
                          }
                          
                      }
                
                
              } else {
                
                //Regular notifications
                if let notifyDate = dateFormat.date(from: date) {
                     
                             //Notification's date
                             var dateComponent = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: notifyDate)
                              
                              //Trigger init
                              let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                              
                              //Request notifications
                              let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
                    
                              //Add notification
                              UNUserNotificationCenter.current().add(request) { (Error) in
                                  print("added")
                                  if let error = Error {
                                      print(error)
                                  }
                                  
                              }
                    
                }
                
              }
        
        
          
          UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in }
          

          
    }
    
}
