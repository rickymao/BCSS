//
//  ScheduleModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ScheduleModuleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SETUP
        
        //Setup
        setupSchedule()
        
        //Sync data
        ref.keepSynced(true)
        
        //Observer
          NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //UI SETUP
        
        //rounding corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //SETUP
        
        events = []
        setupSchedule()
        
    }
    
    //Updates when going into foreground
    @objc func willEnterForeground() {
        
        //SETUP
        
        //Retrieve data
        events = []
        setupSchedule()
        
    }
    
    //OUTLETS
    @IBOutlet weak var blockSegment: UISegmentedControl!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var flexLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    
    //VARIABLES
    var blocks: [Blocks] = []
    let formatter = DateFormatter()
    let persistenceManager = PersistenceManager.shared
    var semester: Int = 0
    let scheduleController = ScheduleModelController()
    let ref = Database.database().reference().child("calendarKeyed")
    var events: [Event] = []
    
    
    //Retrieves data then determines the semester dates by using the database
    func setupSchedule() {
        
            //Get events and checking current semester and setting it
            let eventController = EventModelController()
            let scheduleController = ScheduleModelController()
            
            
                eventController.getEventCollection(completion: { (eventsDB) in
            
                if let newEvents = eventsDB {
                    self.events = newEvents
                    self.semester = scheduleController.getCurrentSemester(events: self.events)
                    
                    self.updateLabels(semester: self.semester, eventsToday: self.events)
                    
                    //Checking for Flex Day
                    if scheduleController.isFlexDay() {
                        
                        //Sets schedule to Flex Day
                        self.updateFlex()
                        self.setupFlex(semester: self.semester, eventsToday: self.events)
                        
                    } else {
                        //Sets schedule to regular day
                        self.setupBlocks(semester: self.semester, eventsToday: self.events)
                        self.updateFlex()
                    }

                } else {
                    self.events = []
                    }
            })


    }
    
    //Depending on which period the user taps on, the information displayed changes in relation to the class
    func setupPeriod(regularTime: String, flexTime: String, eventsToday: [Event], period: Int) {
        
        blocks = blocks.filter { (b) -> Bool in
            b.block == period
        }
        
        let scheduleController = ScheduleModelController()
        func checkFlex() -> Bool {
            return scheduleController.isFlexDay()
        }
        
        
        if scheduleController.checkDayOne(events: eventsToday) {
            
            if let empty = blocks.first?.nameClass?.isEmpty {
                
                if empty {
                    
                    classLabel.text  = "No Class"
                    teacherLabel.text = blocks.first!.nameTeacher
                    timeLabel.text = !(checkFlex()) ? regularTime : flexTime
                    
                } else {
                    classLabel.text = blocks.first!.nameClass
                    teacherLabel.text = blocks.first!.nameTeacher
                    timeLabel.text = !(checkFlex()) ? regularTime : flexTime
                }
                
                
            } else {
                classLabel.text  = "No Class"
                teacherLabel.text = ""
                
                if blocks.count == 0 {
                    timeLabel.text = "Enjoy your break!"
                    
                } else {
                    timeLabel.text = !(checkFlex()) ? regularTime : flexTime
                }
                
            }
            

        }
        else if scheduleController.checkDayTwo(events: eventsToday) {
            if let empty = blocks.first?.nameClass2?.isEmpty {
                
                if empty {
                    
                    classLabel.text  = "No Class"
                    teacherLabel.text = blocks.first!.nameTeacher2
                    timeLabel.text = !(checkFlex()) ? regularTime : flexTime
                    
                } else {
                    classLabel.text = blocks.first!.nameClass2
                    teacherLabel.text = blocks.first!.nameTeacher2
                    timeLabel.text = !(checkFlex()) ? regularTime : flexTime
                }
                
                
            } else {
                classLabel.text  = "No Class"
                teacherLabel.text = ""
                
                if blocks.count == 0 {
                    timeLabel.text = "Enjoy your break!"
                    
                } else {
                    timeLabel.text = !(checkFlex()) ? regularTime : flexTime
                }
                
            }

        }
        else if scheduleController.checkDayZero(events: eventsToday) {
            classLabel.text = "No Class"
            teacherLabel.text = ""
            timeLabel.text = !(checkFlex()) ? regularTime : flexTime
        } else {
            classLabel.text = "No Class"
            timeLabel.text = "Enjoy your break!"
            teacherLabel.text = ""
        }
    }
    

   
    
    //FOR FLEX DAYS
    //Prepares the blocksegment and updates the data for each label
    func setupFlex(semester: Int, eventsToday: [Event]) {
        
        let scheduleController = ScheduleModelController()
        func checkFlex() -> Bool {
            return scheduleController.isFlexDay()
        }
        
        //Sets the semester label and schedule depending on the current semester
        if semester == 1 {
            
            blocks = scheduleController.getBlocks().filter { (b) -> Bool in
                b.semester == Int16(1)
            }
             semesterLabel.text = "Semester 1"
        
        } else if semester == 2 {
            
            blocks = scheduleController.getBlocks().filter { (b) -> Bool in
                b.semester == Int16(2)
            }
            semesterLabel.text = "Semester 2"
        } else {
            semesterLabel.text = ""
        }
        
        //Switching periods
        switch blockSegment.selectedSegmentIndex {
            
            //Period 1
        case 0:
            setupPeriod(regularTime: "8:40 - 10:00", flexTime: "8:40 - 9:45", eventsToday: eventsToday, period: 1)

            //Period Flex
        case 1:
            classLabel.text = "Flex"
            teacherLabel.text = ""
            timeLabel.text = "10:00 - 10:55"
            
            //Period 2
        case 2:

            setupPeriod(regularTime: "10:15 - 11:35", flexTime: "11:00 - 12:05", eventsToday: eventsToday, period: 2)
            

            
            //Period 3
        case 3:

            setupPeriod(regularTime: "12:20 - 1:40", flexTime: "12:50 – 1:55", eventsToday: eventsToday, period: 3)

            //Period 4
        case 4:

            setupPeriod(regularTime: "1:45 - 3:01", flexTime: "2:00 - 3:01", eventsToday: eventsToday, period: 3)
            
         
        default:
            print("Error")
        }
        

    }
    

    
    //FOR REGULAR DAYS
    //Prepares the blocksegment and updates the data for each label
    func setupBlocks(semester: Int, eventsToday: [Event]) {
        
        let scheduleController = ScheduleModelController()
        
        func checkFlex() -> Bool {
            return scheduleController.isFlexDay()
        }

        //Sets the semester label and schedule depending on the current semester
        if semester == 1 {
            blocks = scheduleController.getBlocks()

            blocks = scheduleController.getBlocks().filter { (b) -> Bool in
                b.semester == Int16(1)
                
            }
            
            semesterLabel.text = "Semester 1"
            
        } else if semester == 2 {
            blocks = scheduleController.getBlocks()

            blocks = scheduleController.getBlocks().filter { (b) -> Bool in
                b.semester == Int16(2)
            }
            
            semesterLabel.text = "Semester 2"
        } else {
            semesterLabel.text = ""
        }
        
      //Switching periods
        switch blockSegment.selectedSegmentIndex {
            
            //Period 1
        case 0:
            
            setupPeriod(regularTime: "8:40 - 10:00", flexTime: "8:40 - 9:45", eventsToday: eventsToday, period: 1)
            
            //Period 2
        case 1:

            setupPeriod(regularTime: "10:15 - 11:35", flexTime: "11:00 - 12:05", eventsToday: eventsToday, period: 2)
          
          
        //Period 3
        case 2:

            setupPeriod(regularTime: "12:20 - 1:40", flexTime: "12:50 – 1:55", eventsToday: eventsToday, period: 3)
            
        
        //Period 4
        case 3:
            
            setupPeriod(regularTime: "1:45 - 3:01", flexTime: "2:00 - 3:01", eventsToday: eventsToday, period: 3)
            
        default:
            print("Error")
        }
        
    }
    
    
    //Loads each block on tap
    @IBAction func scheduleTapped(_ sender: Any) {
        
        if scheduleController.isFlexDay() {
            setupFlex(semester: semester, eventsToday: events)
        } else {
            setupBlocks(semester: semester, eventsToday: events)
        }
        
    }
    
    //Set day labels
    func updateLabels(semester: Int, eventsToday: [Event]) {
        
        //Checking Day 0, 1, and 2
        if semester > 0 {
            if scheduleController.checkDayOne(events: eventsToday) {
            dayLabel.text = "Day 1"
        }
            
            else if scheduleController.checkDayTwo(events: eventsToday) {
            dayLabel.text = "Day 2"
        }
            
            else if scheduleController.checkDayZero(events: eventsToday) {
            dayLabel.text = "Day 0"
        } else {
            dayLabel.text = ""
            }
        
        } else {
            dayLabel.text = ""
        }
        
        //Flex label implementation
        if scheduleController.isFlexDay() {
            flexLabel.isHidden = false
        } else {
            flexLabel.isHidden = true
        }
        
        
    }
    
    //Add segment for flex day
   func updateFlex() {


        //Setup segments
    if scheduleController.isFlexDay() && blockSegment.numberOfSegments < 5 {
            
            
        blockSegment.insertSegment(withTitle: "Flex", at: 1, animated: true)
        
        } else {

        if !(scheduleController.isFlexDay()) && blockSegment.numberOfSegments == 5 {
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
