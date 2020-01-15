//
//  AssignmentModelController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-11.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

class AssignmentModelController {
    
    private var assignment: Assignment?
    let persistenceManager = PersistenceManager.shared
    
    init() { }
    
    init(assignment: Assignment) {
        self.assignment = assignment
    }
    //Edit and saves assignments on coredata
    func editAssignment(title: String, course: String, dueDate: String, note: String?, uuid: UUID) {
        do {
                let request: NSFetchRequest<Assignment> = Assignment.fetchRequest()
                request.predicate = NSPredicate(format: "uuid == %@", uuid as NSUUID)
                let context = try persistenceManager.context.fetch(request) as [NSManagedObject]
                let assignments = context as! [Assignment]
                
                if let assignment = assignments.first {
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(assignment.uuid.uuidString)tomorrow", "\(assignment.uuid.uuidString)hour"])
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(assignment.uuid.uuidString)tomorrow", "\(assignment.uuid.uuidString)hour"])
                    
                    context.first!.setValue(title, forKey: "title")
                    context.first!.setValue(course, forKey: "course")
                    context.first!.setValue(dueDate, forKey: "dueDate")
                    
                    if let notes = note {
                        context.first!.setValue(notes, forKey: "notes")
                    }
                    
                    
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "MM/dd/yyyy HH:mm"
                    
                    if let date = dateFormat.date(from: dueDate) {
                        createNotification(name: title, dateOfNotification: date, id: assignment.uuid)
                    }
                   
                    
                
                }
                
                persistenceManager.save()
                
            } catch {
                print("error")
            }
          
    }
    
    //Notifications
    func createNotification(name: String, dateOfNotification: Date, id: UUID) {
        
        let notifykey = id.uuidString + "tomorrow"
        print(notifykey)
        let notifykey2 = id.uuidString + "hour"
        
        //Content
        let notification = UNMutableNotificationContent()
        notification.title = "\(name)"
        notification.body = "Your assignment or test is due tomorrow"
        notification.badge = 1
        notification.sound = UNNotificationSound.default
        
        //Day before notification
        let calendar = Calendar.current
        let date = dateOfNotification
        var notify = calendar.date(bySettingHour: 16, minute: 30, second: 0, of: date)
        notify = calendar.date(byAdding: .day, value: -1, to: notify!)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notify!)
        
        //trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        //Request notifications
        let request = UNNotificationRequest(identifier: notifykey, content: notification, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (Error) in
            
            if let error = Error {
                print(error)
            }
            
        }
        
        
        //Content
        let notification2 = UNMutableNotificationContent()
        notification2.title = "\(name)"
        notification2.body = "Your assignment or test is due in a hour"
        notification2.badge = 1
        notification2.sound = UNNotificationSound.default
        
        //Hour notification
        let date2 = dateOfNotification
        let notify2 = calendar.date(byAdding: .hour, value: -1, to: date2)
        let components2 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notify2!)
        
        //trigger
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: components2, repeats: false)
        
        //Request notifications
        let request2 = UNNotificationRequest(identifier: notifykey2, content: notification2, trigger: trigger2)
        
        UNUserNotificationCenter.current().add(request2) { (Error) in
            
            if let error = Error {
                print(error)
            }
            
        }
        
    }
    
    //Adds a new assignment to coredata
    func addAssignment(title: String, course: String, dueDate: String, notes: String?) -> Assignment {
        
        let assignment = Assignment(context: persistenceManager.context)
            assignment.title = title
            assignment.course = course
            assignment.dueDate = dueDate
            assignment.notes = notes
            assignment.uuid = UUID()
        
        persistenceManager.save()
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy HH:mm"
      
        if let date = dateFormat.date(from: dueDate) {

            createNotification(name: title, dateOfNotification: date, id: assignment.uuid)
            
       
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(requests)
        }
        
            persistenceManager.save()
        
        return assignment

    }
    
    //Gets user's assignments from core data
    func getMyAssignments()-> [Assignment] {
        var assignments: [Assignment] = []
        do {
            
            let context = try persistenceManager.context.fetch(Assignment.fetchRequest()) as [Assignment]
            assignments = context
        } catch {
            print(error)
        }
        return assignments
    }
    
    func deleteAssignment(assignment: Assignment) {
        
        //Deletes the notification associated with the assignment
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(assignment.uuid.uuidString)tomorrow", "\(assignment.uuid.uuidString)hour"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(assignment.uuid.uuidString)tomorrow", "\(assignment.uuid.uuidString)hour"])
        
        
        //Removes the assignment from Core Data
        let persistenceManager = PersistenceManager.shared
        persistenceManager.context.delete(assignment)
        persistenceManager.save()
        

    }
}
