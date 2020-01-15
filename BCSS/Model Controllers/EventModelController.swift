//
//  EventModelController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-11.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class EventModelController {
    
    private var event: Event?
    
   
    init(event: Event) {
     
        self.event = event
    }
    
    init() {
        
    }
    
    //Retrieve current events from database
    func getEventCollection(completion: @escaping ([Event]?) ->  Void) {
            
        
        let ref = Database.database().reference()
        
    ref.child("calendarKeyed").observeSingleEvent(of: .value) { (snapshot) in
        
        var events: [Event] = []
        var title: String
        var date: String
        var location: String
        var description: String
        var time: String
        
        for snapshot in snapshot.children {
            
            
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
                
                events.append(Event(title: title, date: date, location: location, description: description, time: time))
                
    
            }
            
        }
       completion(events)
      }
 
    }
    
    //Gets today's events
    func getTodaysEvents(completion: @escaping ([Event]?) -> Void) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        var events: [Event] = []
        let dateController = DateController()
        let today = dateController.standardizeDate(dateInput: Date())
        
        getEventCollection {(eventsDB) in
            if let newEvents = eventsDB {
                for event in newEvents {
                           
                 if let date = formatter.date(from: event.date) {
                               
                    if date == today {
                                   
                        events.append(event)
                                   
                    }
                               
                }
                           
            }
                     
        } else { events = [] }
        completion(events)
    }
  }
}
