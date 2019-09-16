//
//  ScheduleModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ScheduleModuleViewController: UIViewController {

    //View lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup
        getBlockData()
        
        //Sync data
        ref.keepSynced(true)
        
        //Observer
          NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        //round corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        events = []
        getBlockData()
        
    }
    
    @objc func willEnterForeground() {

        
        //Retrieve data
        events = []
        getBlockData()
        
    }
    
    //Outlets
    @IBOutlet weak var blockSegment: UISegmentedControl!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var flexLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    
    //Variables
    var blocks: [Blocks] = []
    let formatter = DateFormatter()
    let persistenceManager = PersistenceManager.shared
    var semester: Int = 0
    let ref = Database.database().reference().child("calendarKeyed")
    var events: [Event] = []
    
    
    //Retrieves data then determines the semester dates by using the database
    func getBlockData() {
        
        //Database query
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            
            for snapshot in snapshot.children {
                
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
                    
                    self.formatter.dateFormat = "yyyy MM dd"
            
                        self.events.append(Event(title: title, date: date, location: location, description: description, time: time))

                }
                
                
            }
            
            //Finding semester dates
            var semesterOneStart: Date = Date()
            var semesterOneEnd: Date = Date()
            var semesterTwoStart: Date = Date()
            var semesterTwoEnd: Date = Date()
            
            for event in self.events {

                self.formatter.dateFormat = "yyyy MM dd"
                
                //Semester 1
                if event.title == "1st Day of School" {

                    if let formattedDate = self.formatter.date(from: event.date) {
                       semesterOneStart = self.standardizeDate(dateInput: formattedDate)
                        
                    }

                } else if event.title == "Term 2 ENDS" {
                    
                    if let formattedDate = self.formatter.date(from: event.date) {
                        semesterOneEnd = self.standardizeDate(dateInput: formattedDate)
                    }
                    
                } else if event.title == "Term 3 STARTS" {
                    
                    if let formattedDate = self.formatter.date(from: event.date) {
                        semesterTwoStart = self.standardizeDate(dateInput: formattedDate)
                    }
                } else if event.title == "Term 4 ENDS" {
                    
                    if let formattedDate = self.formatter.date(from: event.date) {
                        semesterTwoEnd = self.standardizeDate(dateInput: formattedDate)
                    }
                }




            }
            

            //Semester for user
                let today = self.standardizeDate(dateInput: Date())

                //Semester 1
                if today >= semesterOneStart && today <= semesterOneEnd {
                    
                    self.semester = 1
                    
                    //Set labels
                    self.updateLabels(semester: self.semester, eventsToday: self.events)
                  
                    
                    //Checking for flex day
                    if self.checkFlex() {
                        
                        //setup
                        self.updateFlex()
                        self.setupFlex(semester: 1, eventsToday: self.events)
                    }
                    else {
                        
                        //setup
                        self.setupBlocks(semester: 1, eventsToday: self.events)
                        self.updateFlex()
                    }
                  
                //Semester 2
                } else if today >= semesterTwoStart && today <= semesterTwoEnd {
                    
                    self.semester = 2
                    
                    //Set labels
                    self.updateLabels(semester: self.semester, eventsToday: self.events)
                    
                    //Checking for flex day
                    if self.checkFlex() {
                        
                        
                        //setup
                        self.setupFlex(semester: 2, eventsToday: self.events)
                        self.updateFlex()
                    }
                    else {
                        
                        //setup
                        self.setupBlocks(semester: 2, eventsToday: self.events)
                        self.updateFlex()
                    }
                    
                } else {
                    
                    self.semester = 0
                    
                    //Set labels
                    self.updateLabels(semester: self.semester, eventsToday: self.events)
                    //Checking for flex day
                    if self.checkFlex() {
                        
                        //setup
                        self.setupFlex(semester: 3, eventsToday: self.events)
                        self.updateFlex()
                    }
                    else {
                        
                        //setup
                        self.setupBlocks(semester: 3, eventsToday: self.events)
                        self.updateFlex()
                    }
                    
                    
                    
                }
                
            
            
        }
        
        
    }
    
    //TEST: passed
    //Checking days
    func checkDayOne(events: [Event]) -> Bool {
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var days = events
        
        days = days.filter({ (Event) -> Bool in
            Event.title == "DAY 1"
        })
        
        for day in days {
            
            if day.date == today {
                return true
            }

        }
        return false
        
    }
    
    func checkDayZero(events: [Event]) -> Bool {
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var days = events
        
        days = days.filter({ (Event) -> Bool in
            Event.title == "DAY 0"
        })
        
        for day in days {
            
            if day.date == today {
                return true
            }
            
        }
        return false
        
    }
    
    func checkDayTwo(events: [Event]) -> Bool {
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var days = events
        
        days = days.filter({ (Event) -> Bool in
            Event.title == "DAY 2"
        })
        
        for day in days {
            
            if day.date == today {
                return true
            }
            
        }
        return false
        
    }
    
    //Checking flex days
    func checkFlex() -> Bool {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var flex = events
        
        flex = flex.filter { (Event) -> Bool in
            Event.title == "FlEX TIME"
        }
        
        for flexday in flex {
            
            if flexday.date == today {
                return true
            }
            
        }
        return false
       
    }
    
    //FOR FLEX DAYS
    //Prepares the blocksegment and updates the data for each label
    func setupFlex(semester: Int, eventsToday: [Event]) {
        
        if semester == 1 {
            
            blocks = getBlocks()
            blocks = getBlocks().filter { (b) -> Bool in
                b.semester == Int16(1)
    
            }
            
             semesterLabel.text = "Semester 1"
            
            
        } else if semester == 2 {
            
            blocks = getBlocks()
            blocks = getBlocks().filter { (b) -> Bool in
                b.semester == Int16(2)
            }
            
            semesterLabel.text = "Semester 2"
        } else {
            semesterLabel.text = ""
        }
        
        
        switch blockSegment.selectedSegmentIndex {
            
            //Period 1
        case 0:
            
            blocks = blocks.filter { (b) -> Bool in
                b.block == 1
            }
            
            if checkDayOne(events: eventsToday) {
                
                if let empty = blocks.first?.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                    }
                    
                }
                

            }
            else if checkDayTwo(events: eventsToday) {
                if let empty = blocks.first?.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                    }
                    
                }

            }
            else if checkDayZero(events: eventsToday) {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
                teacherLabel.text = ""
            }
            
            //Period Flex
        case 1:
            
            classLabel.text = "Flex"
            teacherLabel.text = ""
            timeLabel.text = "10:00 - 10:55"
            
            //Period 2
        case 2:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 2
            }
            
            
            if checkDayOne(events: eventsToday) {
                
                if let empty = blocks.first?.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                    }
                    
                }
                

            }
            else if checkDayTwo(events: eventsToday) {
                if let empty = blocks.first?.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                    }
                }

            }
            else if checkDayZero(events: eventsToday) {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
                teacherLabel.text = ""
            }
            
            //Period 3
        case 3:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 3
            }
            
            
            if checkDayOne(events: eventsToday) {
                if let empty = blocks.first?.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                    }
                }

            }
            else if checkDayTwo(events: eventsToday) {
                if let empty = blocks.first?.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                    }
                    
                }

            }
            else if checkDayZero(events: eventsToday) {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
                teacherLabel.text = ""
            }
            
            //Period 4
        case 4:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 4
            }
            
            
            
            if checkDayOne(events: eventsToday) {
                
                if let empty = blocks.first?.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                    }
                    
                }
            
            }
            else if checkDayTwo(events: eventsToday) {
                if let empty = blocks.first?.nameClass2?.isEmpty {
                    
                    if empty {
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                    }
                    
                }

            }
            else if checkDayZero(events: eventsToday) {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
                teacherLabel.text = ""
            }
            
        default:
            print("Error")
        }
        
        
        
        
        
    }
    

    
    //FOR REGULAR DAYS
    //Prepares the blocksegment and updates the data for each label
    func setupBlocks(semester: Int, eventsToday: [Event]) {
        
        if semester == 1 {
            blocks = getBlocks()

            blocks = getBlocks().filter { (b) -> Bool in
                b.semester == Int16(1)
                
            }
            
            semesterLabel.text = "Semester 1"
            
        } else if semester == 2 {
            blocks = getBlocks()

            blocks = getBlocks().filter { (b) -> Bool in
                b.semester == Int16(2)
            }
            
            semesterLabel.text = "Semester 2"
        } else {
            semesterLabel.text = ""
        }
        
      
        switch blockSegment.selectedSegmentIndex {
            
            //Period 1
        case 0:
            
            blocks = blocks.filter { (b) -> Bool in
                b.block == 1
            }
            
            if checkDayOne(events: eventsToday) {
                
                if let empty = blocks.first?.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                    }
                    
                        
                    } else {
                    
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    //checks for non filled semester or break
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"

                    } else {
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                    }
                    
                    
                    }
             
            }
            else if checkDayTwo(events: eventsToday) {
                if let empty = blocks.first?.nameClass2?.isEmpty {
                    
                    if empty {
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    //checks for non filled semester or break
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
                    }
                    
                }
                
            }
            else if checkDayZero(events: eventsToday) {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkFlex()) ? "8:40 - 10:00" : "8:40 - 9:45"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
                teacherLabel.text = ""
            }
            
            //Period 2
        case 1:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 2
            }
      
            
            if checkDayOne(events: eventsToday) {
                
                
                if let empty = blocks.first?.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                    }
                    
                }
                
            }
            else if checkDayTwo(events: eventsToday) {
                if let empty = blocks.first?.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
                    }
                    
                }

            }
            else if checkDayZero(events: eventsToday) {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkFlex()) ? "10:15 - 11:35": "11:00 - 12:05"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
                teacherLabel.text = ""
            }
            
        //Period 3
        case 2:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 3
            }
            
            
            if checkDayOne(events: eventsToday) {
                if let empty = blocks.first?.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                    }
                }
                
            }
            else if checkDayTwo(events: eventsToday) {
                if let empty = blocks.first?.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
                    }
                }

            }
            else if checkDayZero(events: eventsToday) {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkFlex()) ? "12:20 - 1:40" : "12:50 – 1:55"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
                teacherLabel.text = ""
            }
        
        //Period 4
        case 3:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 4
            }
            
 
            
            if checkDayOne(events: eventsToday) {
                
                if let empty = blocks.first?.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                        teacherLabel.text = blocks.first!.nameTeacher
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                    }
                }
  
            }
            else if checkDayTwo(events: eventsToday) {
                if let empty = blocks.first?.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                        teacherLabel.text = blocks.first!.nameTeacher2
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    teacherLabel.text = ""
                    
                    if blocks.count == 0 {
                        timeLabel.text = "Enjoy your break!"
                        
                    } else {
                        timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
                    }
                }
                
            }
            else if checkDayZero(events: eventsToday) {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkFlex()) ? "1:45 - 3:01" : "2:00 - 3:01"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
                teacherLabel.text = ""
            }
            
        default:
            print("Error")
        }
        
    }
    
    
    //Coredata query
    func getBlocks() -> [Blocks] {
        
        do {
        let context = try persistenceManager.context.fetch(Blocks.fetchRequest()) as [Blocks]
        return context
        } catch {
            print(error)
            return [Blocks()]
        }
        
    }
    
    //Loads each block on tap
    @IBAction func scheduleTapped(_ sender: Any) {
        
        if checkFlex() {
            setupFlex(semester: semester, eventsToday: events)
        } else {
            setupBlocks(semester: semester, eventsToday: events)
        }
        
    }
    
    //Set day labels
    func updateLabels(semester: Int, eventsToday: [Event]) {
        
        //Checking Day 0, 1, and 2
        if semester > 0 {
        if checkDayOne(events: eventsToday) {
            dayLabel.text = "Day 1"
        }
            
        else if checkDayTwo(events: eventsToday) {
            dayLabel.text = "Day 2"
        }
            
        else if checkDayZero(events: eventsToday) {
            dayLabel.text = "Day 0"
        } else {
            dayLabel.text = ""
            }
        
        } else {
            dayLabel.text = ""
        }
        
        //Flex label implementation
        if checkFlex() {
            flexLabel.isHidden = false
        } else {
            flexLabel.isHidden = true
        }
        
        
    }
    
    //Add segment for flex day
   func updateFlex() {


        //Setup segments
        if checkFlex() && blockSegment.numberOfSegments < 5 {
            
            
        blockSegment.insertSegment(withTitle: "Flex", at: 1, animated: true)
        
        } else {

        if !(checkFlex()) && blockSegment.numberOfSegments == 5 {
            blockSegment.removeSegment(at: 1, animated: false)
            blockSegment.selectedSegmentIndex = 0
         
            }
        }
    
    
    
    }
    
    //return dates that can be compared for boolean expression
    func standardizeDate(dateInput: Date) -> Date {
        

        let componentDate = Calendar.current.dateComponents([.year, .month, .day], from: dateInput)

        let actualDate = Calendar.current.date(from: componentDate)
        
        if let unwrappedDate = actualDate {
            return unwrappedDate
        } else {
            return Date()
        }
        
        
        
    }
    
}
