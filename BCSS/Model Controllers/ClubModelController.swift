//
//  ClubModelController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-11.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import Foundation
import Firebase
import CoreData
import FirebaseDatabase

class ClubModelController {
    
    private var club: Club?
    let persistenceManager = PersistenceManager.shared
    
    init(club: Club) {
        self.club = club
    }
    
    init() {
        
    }
    
    //Deletes club from coredata
    func removeClub(deleteClub: CoreClub) {
        
        persistenceManager.context.delete(deleteClub)
        persistenceManager.save()
        
    }
    
    //Filters and returns the user's club meetings of that day
    func getTodaysClubMeetings(meetings: [CoreClub]) -> [CoreClub] {
        
        return meetings.filter({ (org) -> Bool in
            
            let dates = org.meeting
            var isCurrent = false
            let calendar = Calendar.current
            
            //Looping through meeting dates for each club to check if the meeting is today regardless of year and month
            dateLoop: for date in dates {
                
                var component = calendar.dateComponents([Calendar.Component.weekday], from: date as Date)
                component.year = 2018
                component.month = 9
                var component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
                component2.year = 2018
                component2.month = 9
                let componentDate = calendar.date(from: component)
                let componentDate2 = calendar.date(from: component2)
                
                
                if componentDate! == componentDate2! {
                    isCurrent = true
                    break dateLoop
                    
                } else {
                    isCurrent = false
                }
                
            }
            return isCurrent
            
            
        })
    
    }
    
    //Gets the user's clubs that they have joined
    func getMyClubCollection() -> [CoreClub] {
        
        let persistenceManager = PersistenceManager.shared
        var coreClubs: [CoreClub] = []
        
        //Retrieve Core Data Clubs
        do {
                let clubs = try persistenceManager.context.fetch(CoreClub.fetchRequest()) as [CoreClub]
                
            coreClubs = clubs
               
                
            } catch {
                print(error)
            }
        
        return coreClubs
            
    }
    
    //Gets the currently available clubs from the database
    func getClubCollection(completion: @escaping ([Club]?) ->  Void) {
                   
            
            let ref = Database.database().reference()
           
           ref.child("clubKeyed").observe(.value) { (snapshot) in
            
            var clubs: [Club] = []
            var club: String
            var owner: String
            var room: String
            var teacher: String
            var description: String
            var email: String
            var hours: String
            var minutes: String
            var dayOfWeek: String
           
           for filteredSnapshot in snapshot.children {
               if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                

                   //Extracting values
                   club = snapshotJSON.childSnapshot(forPath: "Club").value as! String
                   owner = snapshotJSON.childSnapshot(forPath: "Owner").value as! String
                   room = snapshotJSON.childSnapshot(forPath: "Room").value as! String
                   teacher = snapshotJSON.childSnapshot(forPath: "Teacher").value as! String
                   description = snapshotJSON.childSnapshot(forPath: "Description").value as? String ?? " "
                email = snapshotJSON.childSnapshot(forPath: "Email").value as? String ?? "graham.hendry@burnabyschools.ca"
                   hours = snapshotJSON.childSnapshot(forPath: "Hours").value as! String
                   minutes = snapshotJSON.childSnapshot(forPath: "Minutes").value as! String
                   dayOfWeek = snapshotJSON.childSnapshot(forPath: "DayofWeek").value as! String
                   
                   if let hoursInt = Int(hours), let minutesInt = Int(minutes), let dayOfWeekInt = Int(dayOfWeek) {

                       let vc = ClubTableViewController()
                       
                       //Adding to array
                       clubs.append(Club(name: club, teacher: teacher, meeting: [vc.createDate(hours: hoursInt, minutes: minutesInt, dayOfTheWeek: dayOfWeekInt)], room: room, owner: owner, desc: description, email: [email]))
                    
                       
                   }
                   
                
               }
               
               
           }
       completion(clubs)
           
       }
    
       }

}
