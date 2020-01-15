//
//  ClubUpdateController.swift
//  BCSS
//
//  Created by Ricky Mao on 2019-08-24.
//  Copyright © 2019 Ricky Mao. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreData

class ClubUpdateController {
    
    //Variables
    var Clubref = Database.database().reference().child("clubKeyed")
    var coredata = PersistenceManager.shared.context
    
    
    init() { }
    
    //Updates current clubs and their information
    func getUpdates() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClubTableViewController") as? ClubTableViewController
        var clubs = [Club]()
        
        //Data retrieval
        Clubref.observeSingleEvent(of: .value) { (snapshot) in
            
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    let club = snapshotJSON.childSnapshot(forPath: "Club").value as! String
                    let owner = snapshotJSON.childSnapshot(forPath: "Owner").value as! String
                    let room = snapshotJSON.childSnapshot(forPath: "Room").value as! String
                    let teacher = snapshotJSON.childSnapshot(forPath: "Teacher").value as! String
                    
                    let description: String
                    
                    if let desc = snapshotJSON.childSnapshot(forPath: "Description").value as? String {
                        
                        description = desc
                    } else {
                        description = "N/A"
                    }
                    
                    let email: String
                    if let emailStr = snapshotJSON.childSnapshot(forPath: "Email").value as? String {
                        email = emailStr
                    } else {
                        email = "unknown@gmail.com"
                    }
                    
                    let hours = snapshotJSON.childSnapshot(forPath: "Hours").value as! String
                    let minutes = snapshotJSON.childSnapshot(forPath: "Minutes").value as! String
                    
                    let dayOfWeek: String
                    if let day = snapshotJSON.childSnapshot(forPath: "DayofWeek").value as? String {
                        dayOfWeek = day
                    } else {
                        dayOfWeek = "5"
                    }
                    
                    if let hoursInt = Int(hours), let minutesInt = Int(minutes), let dayOfWeekInt = Int(dayOfWeek) {
                        
                        let newClub = Club(name: club, teacher: teacher, meeting: [vc!.createDate(hours: hoursInt, minutes: minutesInt, dayOfTheWeek: dayOfWeekInt)], room: room, owner: owner, desc: description, email: [email])
                        
                        
                        //Adding to array
                        clubs.append(newClub)
                        
                    }
                    
                    
                    
                }
                
                
            }
            
            do {
                
                //Checking club updates
                let updatePending = try self.coredata.fetch(CoreClub.fetchRequest()) as? [CoreClub]
                
                if let updates = updatePending {
                    
                    for organization in updates {
                        
                        if clubs.contains(where: { (club) -> Bool in
                            club.name == organization.name
                        }) {
                            
                            //Updates properties
                            for club in clubs {
                                
                                if club.name == organization.name {
                                    
                                    organization.name = club.name
                                    organization.room = club.room
                                    organization.descriptionClub = club.description
                                    organization.leader = club.clubOwner
                                    organization.sponsor = club.teacher
                                    organization.meeting = club.meetingDates as [NSDate]
                                    
                                    PersistenceManager.shared.save()
                                    
                                }
                                
                            }
                            
                            
                        //Deletes clubs that have been removed
                        } else {
                            PersistenceManager.shared.context.delete(organization)
                            PersistenceManager.shared.save()
                        }
                        
                        
                    }
                    
                }
                

            } catch {
                print(error)
            }
            //Sync data
            self.Clubref.keepSynced(true)
            
        }
        
        
    }

}
