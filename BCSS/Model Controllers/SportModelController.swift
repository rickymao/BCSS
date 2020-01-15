//
//  SportModelController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-11.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class SportModelController {
    
    private var sport: Sports?
    
    init(sport: Sports) {
        self.sport = sport
    }
    
    init() { }
    
    //Check if the user is in the team
    func isInTeam(teamString: String) -> Bool {
        
        let persistenceManager = PersistenceManager.shared
        
        do {
            if let teams = try persistenceManager.context.fetch(Team.fetchRequest()) as? [Team] {
                checkTeams: for team in teams {
                    
                    if team.sport == teamString {
                        
                        return false

                    }
                    else {
                        return true

                    }
                    
                }
            }
        } catch {
            print(error)
        }
        
        return false
        
    }
    
    func addMySport(name: String, grade: String, coach: String, season: String, practiceDate: NSDate, sponsor: String) {
        
        let persistenceManager = PersistenceManager.shared
        let context = PersistenceManager.shared.context
        
        //Initializes and creates a coredata team to add to the user's team list
               let team = Team(context: context)
               team.sport = name
               team.grade = grade
               team.coach = coach
               team.season = season
               team.teacher = sponsor
               team.practiceTime = practiceDate as NSDate
               persistenceManager.save()
        
        
    }
    
    //Gets currently available sports from database
    func getSportCollection(completion: @escaping ([Sports]?) -> Void) {
        
        let ref = Database.database().reference()
        
        ref.child("sportKeyed").observe(.value) { (snapshot) in
            
            var sports: [Sports] = []
            
            var name: String
            var coach: String
            var teacher: String
            var season: String
            var email: String
            
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    name = snapshotJSON.childSnapshot(forPath: "Name").value as! String
                    coach = snapshotJSON.childSnapshot(forPath: "Coach").value as! String
                    teacher = snapshotJSON.childSnapshot(forPath: "Teacher").value as! String
                    season = snapshotJSON.childSnapshot(forPath: "Season").value as! String
                    email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
                    
                    //Adding to array
                    sports.append(Sports(name: name, coach: coach, teacher: teacher, season: season, email: email))
                    
                }
                
                
            }
            completion(sports)
        }
        
    }

    
    
    
    
    
    
    
    
    
}
