//
//  AssignmentsTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-04.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import UserNotifications

class AssignmentsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(requests)
        }
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //Add-Button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "add"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addTapped))
        
        //setting assignments
        do {
            let context = try persistenceManager.context.fetch(Homework.fetchRequest()) as [Homework]
            assignments = context
        } catch {
            print(error)
        }
        
        //Tableview background
        if assignments.count == 0 {
        self.tableView.backgroundView = background
        self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //setting assignments
        do {
            let context = try persistenceManager.context.fetch(Homework.fetchRequest()) as [Homework]
            assignments = context
        } catch {
            print(error)
        }
    
        
        //Tableview background
        if assignments.count == 0 {
            self.tableView.backgroundView = background
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
        tableView.reloadData()
    }
    
    
    var assignments: [Homework] = []
    let persistenceManager = PersistenceManager.shared
    @IBOutlet var background: UIView!
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addTapped() {
        
        performSegue(withIdentifier: "addAssignmentSegue", sender: nil)
    
    }
    
    override func willMove(toParent parent: UIViewController?) {
        
        if let vcs = self.navigationController?.viewControllers {
            if vcs.contains(where: { return $0 is MyFeedViewController
            }) {
                
                navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 0.612, green: 0.137, blue: 0.157, alpha: 100)
                
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 100)]
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addAssignmentSegue" {
            
            let addVC = segue.destination as! AddAssignmentTableViewController
            addVC.addAssignmentDelegate = self
        
        }
        if segue.identifier == "infoAssignmentSegue" {
            

            let infoVC = segue.destination as! InfoAssignmentTableViewController
            if let selected = tableView.indexPathForSelectedRow?.row {
                infoVC.name =  "\(assignments[selected].title!)"
                infoVC.course = "\(assignments[selected].course!)"
                infoVC.dueDate =  "\(assignments[selected].dueDate!)"
                infoVC.notes = assignments[selected].notes
                infoVC.uuid = assignments[selected].uuid
            
            
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let doneButton = UITableViewRowAction.init(style: .normal, title: "Done") { (doneButton, IndexPath) in
            print("\(self.assignments[indexPath.row].uuid.uuidString)tomorrow")
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(self.assignments[indexPath.row].uuid.uuidString)tomorrow", "\(self.assignments[indexPath.row].uuid.uuidString)hour"])
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(self.assignments[indexPath.row].uuid.uuidString)tomorrow", "\(self.assignments[indexPath.row].uuid.uuidString)hour"])
    
            
            self.persistenceManager.context.delete(self.assignments[indexPath.row])
            self.persistenceManager.save()

            self.assignments.remove(at: indexPath.row)
            
           
                //Tableview background
                if self.assignments.count == 0 {
                    self.tableView.backgroundView = self.background
                    self.tableView.separatorStyle = .none
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .singleLine
                }
        
            
            tableView.reloadData()
        }
        
        doneButton.backgroundColor = UIColor.green
        return [doneButton]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return assignments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! AssignmentTableViewCell
        
        cell.titleLabel.text = assignments[indexPath.row].title
        cell.dueDateLabel.text = "Due on \(assignments[indexPath.row].dueDate!)"
        
        
        return cell
    }
    
 
}

extension AssignmentsTableViewController: addAssignmentDelegate {
    
    func addAssignment(title: String, course: String, dueDate: String, notes: String?) {
        
        let homework = Homework(context: persistenceManager.context)
            homework.title = title
            homework.course = course
            homework.dueDate = dueDate
            homework.notes = notes
            homework.uuid = UUID()
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy HH:mm"
      
        if let date = dateFormat.date(from: dueDate) {

            setupNotification(name: title, dateOfNotification: date, id: homework.uuid)
            
       
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(requests)
        }
        
            persistenceManager.save()
        
        assignments.append(homework)
        self.navigationController?.popViewController(animated: true)
        
        tableView.reloadData()
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
    
    
}
