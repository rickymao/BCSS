//
//  EventsModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseDatabase

class EventsModuleViewController: UIViewController {
    
    //VARIABLES
    let persistenceManager = PersistenceManager.shared
    var events: [Event] = []
    var filteredEvents: [Event] = []
    let eventController = EventModelController()
    let eventRef = Database.database().reference().child("calendarKeyed")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Rounding corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
        
        //SETUP
        
        //Observer
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        
        //Sync data
        eventRef.keepSynced(true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //SETUP
        
        //Retrieve data
        events = []
        checkEvent()
       eventsTable.reloadData()
        
    }
    

    //OUTLETS
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet var background: UIView!
    
    
    func checkEvent() {
        
        //Getting events from database
        eventController.getEventCollection { (eventsDB) in
            if let newEvents = eventsDB {
                self.events = newEvents
                
                    //Checking today's events
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy MM dd"
                    let today = formatter.string(from: Date())
                    
                self.filteredEvents = self.events.filter { (Event) -> Bool in
                        Event.date == today
                    }

                self.refreshTableView()
                    
                } else {
                self.events = []
            }
        }
            
}
        
    

       @objc func willEnterForeground() {
    
        refreshTableView()
        
    }
    
    //Reloads tableview and sets background to empty if there are no events
    func refreshTableView() {
        
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


//Showing the eventCells
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
