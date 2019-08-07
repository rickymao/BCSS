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
