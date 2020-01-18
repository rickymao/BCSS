//
//  OnboardingViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2019-06-27.
//  Copyright © 2019 Ricky Mao. All rights reserved.

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseDatabase
import SystemConfiguration

class OnboardingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //OUTLETS
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Show loading icon
        loadingIcon.startAnimating()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //NETWORK SETUP
        
        //Check wifi
        let networkChecker = NetworkController()
        
        if !networkChecker.checkWiFi() {
            
            let internetAlert = UIAlertController(title: "No Connection", message: "WiFi is needed for first-time setup", preferredStyle: UIAlertController.Style.alert)
            
            let findNetworkAction = UIAlertAction(title: "Network Settings", style: UIAlertAction.Style.default) { (action) in
                
                self.openSettings()
                
            }
            
            internetAlert.addAction(findNetworkAction)
            
            present(internetAlert, animated: true, completion: nil)
            
            
        } else {
            
            //SETUP
            setup()
            
            //Segue to user's feed
            unowned let userdefaults = UserDefaults.standard
            userdefaults.set(true, forKey: "FirstLaunch")
            
            performSegue(withIdentifier: "gotoFeed", sender: nil)
        }
        
    }
    
    //Initializes and sets up school's content
    func setup() {
        
        setupNotifications()
        setupClubs()
        setupSports()
        setupSchedule()
        setupTeachers()
        setupCalendar()
        
        
    }
    
    //Segue to the student's feed
    func gotoFeed() {
        
        var vc: UIViewController
        let sb = UIStoryboard(name: "MyFeed", bundle: nil)
        
        vc = sb.instantiateViewController(withIdentifier: "MyFeedViewController") as! MyFeedViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    //Opens settings app
    func openSettings() {
        
        let shared = UIApplication.shared
        if let url = URL(string: UIApplication.openSettingsURLString) {
            
            shared.open(url, options: [:]) { (success) in
                
            }
        }
        
        
    }

    
    //Creates notifications for important events (e.g. Flex Time)
    func setupNotifications() {
        
        var events: [Event] = []
        let notificationController = NotificationController()
        let eventController = EventModelController()
        
        eventController.getEventCollection { (newEvents) in
            if let addedEvents =  newEvents {
                events = addedEvents
            } else {
                events = []
            }
        }
        
        for event in events {
            
            notificationController.createNotification(title: "Flex Time tomorrow!", body: "Remember to bring assignments to work on!", date: event.date)
                
        }
        

        
    }
    
    //Creates the blocks for the student schedules
    func setupSchedule() {
        
        let scheduleController = ScheduleModelController()
        
        scheduleController.setupBlocks()
        
        
    }
    
    //Retrieve the current clubs from Firebase
    func setupClubs() {
        
        let clubController = ClubModelController()
        
        clubController.getClubCollection { (clubs) in
            if let newClubs = clubs {
                Club.clubs = newClubs
            } else {
                Club.clubs = []
            }
        }

        

    }

    //Retrieve current sports teams from Firebase
    func setupSports() {
        
        let sportController = SportModelController()
        
        sportController.getSportCollection { (sports) in
            if let newSports = sports {
                Sports.sports = newSports
            } else {
                Sports.sports = []
            }
        }

        
    }
    
    //Retrieve current staff directory from Firebase
    func setupTeachers() {
        
        let teacherController = TeacherModelController()
        
        teacherController.getTeacherCollection { (teachers) in
            if let newTeachers = teachers {
                Teacher.teachers = newTeachers
            } else {
                Teacher.teachers = []
            }
        }
        
    }
    
    //Retrieve currently scheduled events from Firebase
    func setupCalendar() {
        
        let eventController = EventModelController()
        
        eventController.getEventCollection { (events) in
            if let newEvents = events {
                Event.events = newEvents
            } else {
                Event.events = []
            }
            
        }
        
        
        
    }
    
    }


