//
//  EventsModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseDatabase

class EventsModuleViewController: UIViewController {
    
    
    let persistenceManager = PersistenceManager.shared
    var events: [Event] = []
    var filteredEvents: [Event] = []
    let eventRef = Database.database().reference().child("calendarKeyed")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Observer
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //Round corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
        
        
        //Sync data
        eventRef.keepSynced(true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Retrieve data
        events = []
        checkEvent()
        

    
      
       eventsTable.reloadData()
        
    }
    

    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet var background: UIView!
    
    
    func checkEvent() {
        
        eventRef.observeSingleEvent(of: .value) { (snapshot) in
            
            for snapshot in snapshot.children {
                
                var title: String
                var date: String
                var location: String
                var description: String
                var time: String
                
                
                if let snapshotJSON = snapshot as? DataSnapshot {
                    
               title = snapshotJSON.childSnapshot(forPath: "Title").value as! String
                    
                    date = snapshotJSON.childSnapshot(forPath: "Date").value as! String
                    
                    if snapshotJSON.childSnapshot(forPath: "Location").exists() {
                        location = snapshotJSON.childSnapshot(forPath: "Location").value as! String
                    } else {
                        location = "School"
                    }
                    
                    if snapshotJSON.childSnapshot(forPath: "Description").exists() {
                        description = snapshotJSON.childSnapshot(forPath: "Description").value as! String
                    } else {
                        description = "There is currently no extra information."
                    }
                    
                    if snapshotJSON.childSnapshot(forPath: "Time").exists() {
                        time = snapshotJSON.childSnapshot(forPath: "Time").value as! String
                    } else {
                        time = "N/A"
                    }
                    
                    self.events.append(Event(title: title, date: date, location: location, description: description, time: time))
                    
                }
                
                
                
                
                
            }
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy MM dd"
            let today = formatter.string(from: Date())
            
            self.filteredEvents = self.events.filter { (Event) -> Bool in
                Event.date == today
            }
            
            if self.filteredEvents.count == 0 {
                self.eventsTable.backgroundView = self.background
                self.eventsTable.separatorStyle = .none
            } else {
                self.eventsTable.backgroundView = nil
                self.eventsTable.separatorStyle = .singleLine
            }
            
            self.eventsTable.reloadData()
            
        }
        
        
        
        
    }
    
    @objc func willEnterForeground() {
        

        if filteredEvents.count == 0 {
            eventsTable.backgroundView = background
            eventsTable.separatorStyle = .none
        } else {
            eventsTable.backgroundView = nil
            eventsTable.separatorStyle = .singleLine
        }
        
        eventsTable.reloadData()
        
        
    }
    
    //Sends data to info viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dateFormat = DateFormatter()
        
        if segue.identifier == "eventSegue" {
            
            
            let eventInfoVC = segue.destination as! EventTableViewController
            
            guard let indexSelect = eventsTable.indexPathForSelectedRow?.row else {return}
            
                let selected = filteredEvents[indexSelect]
                
                
                var convertedDate: String = String()
                
                eventInfoVC.eventNameString = selected.title
                eventInfoVC.eventTimeString = selected.time
                eventInfoVC.eventLocationString = selected.location
                eventInfoVC.eventDescString = selected.description
                
                
                
                
                dateFormat.dateFormat = "yyyy mm dd"
                if let date = dateFormat.date(from: selected.date) {
                    dateFormat.dateFormat = "EEEE, MMM d, yyyy"
                    convertedDate = dateFormat.string(from: date)
                    
                }
            
                eventInfoVC.eventDateString = convertedDate
                
            
        }
        
        
        
        
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
