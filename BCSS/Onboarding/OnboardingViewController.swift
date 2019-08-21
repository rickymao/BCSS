//
//  OnboardingViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2019-06-27.
//  Copyright © 2019 Treeline. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseDatabase

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        loadingIcon.startAnimating()

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //setup
        setupNotifications()
        setupClubs()
        setupSports()
        setupSchedule()
        setupTeachers()
        setupCalendar()
        performSegue(withIdentifier: "gotoFeed", sender: nil)
        
    }
    

    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    func setupNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in }
        
        let dateFormat = DateFormatter()
        let events = Event.events
        
        //Flex Day notification setup
        for event in events {
            if event.title == "Flex Day" {
                
                //Content
                let notification = UNMutableNotificationContent()
                notification.title = "Flex Day Tomorrow"
                notification.body = "Make sure to bring some assignments to work on!"
                notification.badge = 0
                notification.sound = UNNotificationSound.default
                
                //Day before notification
                let calendar = Calendar.current
                dateFormat.dateFormat = "yyyy/MM/dd"
                
                if let date = dateFormat.date(from: event.date) {
                    let collab = calendar.date(byAdding: .day, value: -1, to: date)
                    var dateComponent = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: collab!)
                    dateComponent.hour = 20
                    
                    //trigger
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    
                    //Request notifications
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { (Error) in
                        
                        if let error = Error {
                            print(error)
                        }
                        
                    }
                    
                }
                
                
            }
            
            
            
        }
        
        
        
        
        

        print("First Launch")
        

        
    }
    
    func gotoFeed() {
        
        var vc: UIViewController
        let sb = UIStoryboard(name: "MyFeed", bundle: nil)
        
        vc = sb.instantiateViewController(withIdentifier: "MyFeedViewController") as! MyFeedViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func setupSchedule() {
        
        
        unowned let persistenceManager = PersistenceManager.shared
        
        //Setup schedule
        let blockXsem1 = Blocks(context: persistenceManager.context)
        blockXsem1.blockX = true
        blockXsem1.block = 0
        blockXsem1.semester = 1
        
        let block1sem1 = Blocks(context: persistenceManager.context)
        block1sem1.block = 1
        block1sem1.semester = 1
        
        let block2sem1 = Blocks(context: persistenceManager.context)
        block2sem1.block = 2
        block2sem1.semester = 1
        
        let block3sem1 = Blocks(context: persistenceManager.context)
        block3sem1.block = 3
        block3sem1.semester = 1
        
        let block4sem1 = Blocks(context: persistenceManager.context)
        block4sem1.block = 4
        block4sem1.semester = 1
        
        let blockXsem2 = Blocks(context: persistenceManager.context)
        blockXsem2.blockX = true
        blockXsem2.block = 0
        blockXsem2.semester = 2
        
        let block1sem2 = Blocks(context: persistenceManager.context)
        block1sem2.block = 1
        block1sem2.semester = 2
        
        let block2sem2 = Blocks(context: persistenceManager.context)
        block2sem2.block = 2
        block2sem2.semester = 2
        
        let block3sem2 = Blocks(context: persistenceManager.context)
        block3sem2.block = 3
        block3sem2.semester = 2
        
        let block4sem2 = Blocks(context: persistenceManager.context)
        block4sem2.block = 4
        block4sem2.semester = 2
        
        persistenceManager.save()
        
        
        
    }
    
    func setupClubs() {
        
            let ref = Database.database().reference()
        
            ref.child("clubKeyed").observe(.value) { (snapshot) in
                
                for filteredSnapshot in snapshot.children {
                    if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                        
                        //Extracting values
                        let club = snapshotJSON.childSnapshot(forPath: "Club").value as! String
                        let owner = snapshotJSON.childSnapshot(forPath: "Owner").value as! String
                        let room = snapshotJSON.childSnapshot(forPath: "Room").value as! String
                        let teacher = snapshotJSON.childSnapshot(forPath: "Teacher").value as! String
                        let description = snapshotJSON.childSnapshot(forPath: "Description").value as! String
                        let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
                        let hours = snapshotJSON.childSnapshot(forPath: "Hours").value as! String
                        let minutes = snapshotJSON.childSnapshot(forPath: "Minutes").value as! String
                        let dayOfWeek = snapshotJSON.childSnapshot(forPath: "DayofWeek").value as! String
                        
                        if let hoursInt = Int(hours), let minutesInt = Int(minutes), let dayOfWeekInt = Int(dayOfWeek) {

                            let vc = ClubTableViewController()
                            
                            //Adding to array
                            Club.clubs.append(Club(name: club, teacher: teacher, meeting: [vc.createDate(hours: hoursInt, minutes: minutesInt, dayOfTheWeek: dayOfWeekInt)], room: room, owner: owner, desc: description, email: [email]))
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
            
                
            }
    }
    
    func setupSports() {
        
        let ref = Database.database().reference()
        
        ref.child("sportKeyed").observe(.value) { (snapshot) in
            
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    let name = snapshotJSON.childSnapshot(forPath: "Name").value as! String
                    let coach = snapshotJSON.childSnapshot(forPath: "Coach").value as! String
                    let teacher = snapshotJSON.childSnapshot(forPath: "Teacher").value as! String
                    let season = snapshotJSON.childSnapshot(forPath: "Season").value as! String
                    let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
                    
                    //Adding to array
                    Sports.sports.append(Sports(name: name, coach: coach, teacher: teacher, season: season, email: email))
                    
                }
                
                
            }
            
        }
        
        
        
    }
    
    func setupTeachers() {
        
        let ref = Database.database().reference()
        
        
        ref.child("teacherKeyed").observeSingleEvent(of: .value) { (snapshot) in
            
            //Collecting all filtered snapshots
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    let lastName = snapshotJSON.childSnapshot(forPath: "LegalLast").value as! String
                    let firstName = snapshotJSON.childSnapshot(forPath: "LegalFirst").value as! String
                    let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
                    let department = snapshotJSON.childSnapshot(forPath: "Department").value as? String
                    let type = snapshotJSON.childSnapshot(forPath: "Type").value as! String
                    let homeroom = snapshotJSON.childSnapshot(forPath: "homeroom").value as? String
                    let fullName = firstName + " " + lastName
                    
                    
                    Teacher.teachers.append(Teacher(name: fullName, email: email, department: department, type: type, homeroom: homeroom))
                    
                }
                
            }
            
        }
        
        
        
        
        
        
    }
    
    func setupCalendar() {
        
        let eventRef = Database.database().reference().child("calendarKeyed")
        
        
        
        eventRef.observeSingleEvent(of: .value) { (snapshots) in
            
            for snapshot in snapshots.children {
                
                if let snapshotJSON = snapshot as? DataSnapshot {
                    
                    var title: String
                    var date: String
                    var location: String
                    var description: String
                    var time: String
                    
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
                    
                    
                     Event.events.append(Event(title: title, date: date, location: location, description: description, time: time))
                    
                    
                }
                
                
                
            }
            
        }
        
        
        
        
        
    }
    
    
    
        
        
        
    }


