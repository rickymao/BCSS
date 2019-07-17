//
//  EventsModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import UserNotifications

class EventsModuleViewController: UIViewController {
    
    
    let persistenceManager = PersistenceManager.shared
    var events: [Event] = Event.events
    var filteredEvents: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Observer
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        
        
        //Round corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true

        // Do any additional setup after loading the view.
        filteredEvents = checkEvent(events: events)
        
        if filteredEvents.count == 0 {
            eventsTable.backgroundView = background
            eventsTable.separatorStyle = .none
        } else {
            eventsTable.backgroundView = nil
            eventsTable.separatorStyle = .singleLine
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       filteredEvents = checkEvent(events: events)
        
        if filteredEvents.count == 0 {
            eventsTable.backgroundView = background
            eventsTable.separatorStyle = .none
        } else {
            eventsTable.backgroundView = nil
            eventsTable.separatorStyle = .singleLine
        }
        
       eventsTable.reloadData()
        
    }
    

    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet var background: UIView!
    
    
    func checkEvent(events: [Event]) -> [Event] {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let today = formatter.string(from: Date())
        
        return events.filter { (Event) -> Bool in
            Event.date == today
        }
        
        
    }
    
    @objc func willEnterForeground() {
        
        
        filteredEvents = checkEvent(events: events)
        
        if filteredEvents.count == 0 {
            eventsTable.backgroundView = background
            eventsTable.separatorStyle = .none
        } else {
            eventsTable.backgroundView = nil
            eventsTable.separatorStyle = .singleLine
        }
        
        eventsTable.reloadData()
        
        
    }
    
    //Notifications
    /*func setupNotification(name: String, datesOfNotification: [Events]) {
        
        let notifykey = "/(name) day before"
        let notifykey2 = "/(name) hour before"
        
        //Content
        let notification = UNMutableNotificationContent()
        notification.title = "Collaboration Day"
        notification.body = "Tomorrow is Collab day!"
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
        notification2.title = "Collaboration Day"
        notification2.body = "Today is Collab Day!"
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
 
 */
    
    
    
    @IBAction func segueTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "eventsModuleSegue", sender: nil)
        
    }
    
    
    
}

extension EventsModuleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = eventsTable.dequeueReusableCell(withIdentifier: "eventCells", for: indexPath)
        
        event.textLabel?.text = filteredEvents[indexPath.row].title
        
        return event
    }
    
 
    
}
