//
//  InfoAssignmentTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-09.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class InfoAssignmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBarButtonSetUp()
        
        //Input-View for Due Date
        let date = UIDatePicker()
        let current = NSDate()
        
        date.minimumDate = current as Date
        date.setDate(current as Date, animated: true)
        date.addTarget(self, action: #selector(dateChanged(date:)), for: .valueChanged)
        dueDateAssignment.inputView = date
        
        let toolBarDone = UIToolbar()
        toolBarDone.sizeToFit()
        dueDateAssignment.inputAccessoryView = toolBarDone
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //End Edits
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEditing(tap:)))
        
        view.addGestureRecognizer(tap)
        
        //Setup Information for Assignment
        titleAssignment.text = name
        classAssignment.text = course
        dueDateAssignment.text = dueDate
        notesAssignment.text = notes
        
    }
    
    var name: String!
    var course: String!
    var dueDate: String!
    var notes: String!
    var uuid: UUID!
    let persistenceManager = PersistenceManager.shared
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var titleAssignment: UITextField!
    @IBOutlet weak var classAssignment: UITextField!
    @IBOutlet weak var dueDateAssignment: UITextField!
    @IBOutlet weak var notesAssignment: UITextView!
    
    @objc func dateChanged(date: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dueDateAssignment.text = dateFormatter.string(from: date.date)
        
        
    }
    
    
    func saveBarButtonSetUp() {
        
        let bar = UIBarButtonItem(barButtonSystemItem: .save
            , target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = bar
        
        
    }
    
    
    @objc func endEditing(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func setCurrentDate(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dueDateAssignment.text = dateFormatter.string(from: Date())
    }
    
    //Notifications
    func setupNotification(name: String, dateOfNotification: Date, id: UUID) {
        
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
    
    
    @objc func saveTapped() {
        
        if (titleAssignment.text?.isEmpty)! {
            
            let alertMissing = UIAlertController(title: "Warning", message: "Please fill in the title!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            
            return
            
        }
            
        else if (classAssignment.text?.isEmpty)! {
            
            let alertMissing = UIAlertController(title: "Warning", message: "Please fill in the class!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            
            return
            
            
        } else if (dueDateAssignment.text?.isEmpty)! {
            
            let alertMissing = UIAlertController(title: "Warning", message: "Please fill in the due date!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            
            return
            
        }
        
        do {
            let request: NSFetchRequest<Homework> = Homework.fetchRequest()
            request.predicate = NSPredicate(format: "uuid == %@", uuid as NSUUID)
            let context = try persistenceManager.context.fetch(request) as [NSManagedObject]
            let assignments = context as! [Homework]
            
            if let assignment = assignments.first {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(assignment.uuid.uuidString)tomorrow", "\(assignment.uuid.uuidString)hour"])
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(assignment.uuid.uuidString)tomorrow", "\(assignment.uuid.uuidString)hour"])
                
                context.first!.setValue(titleAssignment.text, forKey: "title")
                context.first!.setValue(classAssignment.text, forKey: "course")
                context.first!.setValue(dueDateAssignment.text, forKey: "dueDate")
                context.first!.setValue(notesAssignment.text, forKey: "notes")
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "MM/dd/yyyy HH:mm"
                
                if let date = dateFormat.date(from: dueDateAssignment.text!) {
                    setupNotification(name: titleAssignment.text!, dateOfNotification: date, id: assignment.uuid)
                }
               
                
            
            }
            
            persistenceManager.save()
            
        } catch {
            print("error")
        }
      
        //returns back to menu
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }



}
