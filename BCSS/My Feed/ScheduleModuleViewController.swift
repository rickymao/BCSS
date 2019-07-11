//
//  ScheduleModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class ScheduleModuleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if checkCollab() {
            
            blockSegment.insertSegment(withTitle: "Collab", at: 1, animated: true)
            
            
        } else {
            
            if blockSegment.numberOfSegments == 5 {
                blockSegment.removeSegment(at: 1, animated: false)
                blockSegment.selectedSegmentIndex = 0
            }
        }
        

        
        //Checking Day 0, 1, and 2
        
        if checkDayOne() {
            dayLabel.text = "Day 1"
        }
            
        else if checkDayTwo() {
            dayLabel.text = "Day 2"
        }
            
        else if checkDayZero() {
            dayLabel.text = "Day 0"
        }
        else {
            dayLabel.text = ""
        }
        
        
        //Observer
          NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        
        
        //Checking Collab
        if checkCollab() {
            setupCollab()
            collabLabel.isHidden = false
        } else {
            setupBlocks()
            collabLabel.isHidden = true
        }
        
        
        
        //round corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if checkCollab() && blockSegment.numberOfSegments != 5 {
            
            blockSegment.insertSegment(withTitle: "Collab", at: 1, animated: true)
            
            
        }
            
            if !(checkCollab()) && blockSegment.numberOfSegments == 5 {
                 blockSegment.selectedSegmentIndex = 0
                blockSegment.removeSegment(at: 1, animated: false)
              
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        //Checking Day 0, 1, and 2
        
        if checkDayOne() {
            dayLabel.text = "Day 1"
        }
        
        else if checkDayTwo() {
            dayLabel.text = "Day 2"
        }
        
        else if checkDayZero() {
            dayLabel.text = "Day 0"
        }
        else {
            dayLabel.text = ""
        }
        
        //Checking Collab
        if checkCollab() {
            setupCollab()
            collabLabel.isHidden = false
        } else {
            setupBlocks()
            collabLabel.isHidden = true
        }
        
        
        
    }
    
    @IBOutlet weak var blockSegment: UISegmentedControl!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var collabLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    

    var blocks: [Blocks] = []
    let formatter = DateFormatter()
    let persistenceManager = PersistenceManager.shared
    
    func checkSemester() -> Bool {
        
        formatter.dateFormat = "MM/dd/yyyy"
        let now = Date()
        let semester1 = "09/04/2018"
        let semester2 = "01/07/2019"
        
        guard let sem1 = formatter.date(from: semester1), let sem2 = formatter.date(from: semester2) else { return false }
        if now >= sem1 && now < sem2 {
            return true
        } else {
            return false
        }
        
    }
    
    @objc func willEnterForeground() {
        
        if checkCollab() && blockSegment.numberOfSegments != 5 {
            
            blockSegment.insertSegment(withTitle: "Collab", at: 1, animated: true)
            
            
        }
        
        if !(checkCollab()) && blockSegment.numberOfSegments == 5 {
            blockSegment.removeSegment(at: 1, animated: false)
            blockSegment.selectedSegmentIndex = 0
        }
        
        
 
        //Checking Collab
        if checkCollab() {
            setupCollab()
            collabLabel.isHidden = false
        } else {
            setupBlocks()
            collabLabel.isHidden = true
        }

        //Checking Day 0, 1, and 2
        
        if checkDayOne() {
            dayLabel.text = "Day 1"
        }
        
        if checkDayTwo() {
            dayLabel.text = "Day 2"
        }
        
        if checkDayZero() {
            dayLabel.text = "Day 0"
        }
        
    }
    
    func checkDayOne() -> Bool {
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var days = Event.events
        
        days = days.filter({ (Event) -> Bool in
            Event.title == "Day 1"
        })
        
        for day in days {
            
            if day.date == today {
                return true
            }
            
        }
        return false
        
    }
    
    func checkDayZero() -> Bool {
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var days = Event.events
        
        days = days.filter({ (Event) -> Bool in
            Event.title == "Day 0"
        })
        
        for day in days {
            
            if day.date == today {
                return true
            }
            
        }
        return false
        
    }
    
    func checkDayTwo() -> Bool {
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var days = Event.events
        
        days = days.filter({ (Event) -> Bool in
            Event.title == "Day 2"
        })
        
        for day in days {
            
            if day.date == today {
                return true
            }
            
        }
        return false
        
    }
    
    func checkCollab() -> Bool {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var collabs = Event.events
        
        collabs = collabs.filter { (Event) -> Bool in
            Event.title == "Collaboration Day"
        }
        
        for collab in collabs {
            
            if collab.date == today {
                return true
            }
            
        }
        return false
       
    }
    
    func setupCollab() {
        
        blocks = getBlocks()
        
        if checkSemester() {
            
            blocks = getBlocks().filter { (b) -> Bool in
                b.semester == Int16(1)
    
            }
            
             semesterLabel.text = "Semester 1"
            
            
        } else {
            
            blocks = getBlocks().filter { (b) -> Bool in
                b.semester == Int16(2)
            }
            
            semesterLabel.text = "Semester 2"
        }
        
        
        switch blockSegment.selectedSegmentIndex {
            
        case 0:
            
            blocks = blocks.filter { (b) -> Bool in
                b.block == 1
            }
            
            if checkDayOne() {
                
                if let empty = blocks.first!.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                
                teacherLabel.text = blocks.first!.nameTeacher
                timeLabel.text = !(checkCollab()) ? "8:40 - 10:00" : "8:40 - 9:45"
            }
            else if checkDayTwo() {
                if let empty = blocks.first!.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher2
                timeLabel.text = !(checkCollab()) ? "8:40 - 10:00" : "8:40 - 9:45"
            }
            else if checkDayZero() {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkCollab()) ? "8:40 - 10:00" : "8:40 - 9:45"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
            }
            
        case 1:
            
            classLabel.text = "Collab"
            teacherLabel.text = ""
            timeLabel.text = "10:00 - 10:55"
            
        case 2:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 2
            }
            
            
            if checkDayOne() {
                
                if let empty = blocks.first!.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                
                teacherLabel.text = blocks.first!.nameTeacher
                timeLabel.text = !(checkCollab()) ? "10:15 - 11:35": "11:00 - 12:05"
            }
            else if checkDayTwo() {
                if let empty = blocks.first!.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher2
                timeLabel.text = !(checkCollab()) ? "10:15 - 11:35": "11:00 - 12:05"
            }
            else if checkDayZero() {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkCollab()) ? "10:15 - 11:35": "11:00 - 12:05"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
            }
        case 3:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 3
            }
            
            
            if checkDayOne() {
                if let empty = blocks.first!.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher
                timeLabel.text = !(checkCollab()) ? "12:20 - 1:40" : "12:50 – 1:55"
            }
            else if checkDayTwo() {
                if let empty = blocks.first!.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher2
                timeLabel.text = !(checkCollab()) ? "12:20 - 1:40" : "12:50 – 1:55"
            }
            else if checkDayZero() {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkCollab()) ? "12:20 - 1:40" : "12:50 – 1:55"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
            }
        case 4:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 4
            }
            
            
            
            if checkDayOne() {
                
                if let empty = blocks.first!.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                
                teacherLabel.text = blocks.first!.nameTeacher
                timeLabel.text = !(checkCollab()) ? "1:45 - 3:01" : "2:00 - 3:01"
            }
            else if checkDayTwo() {
                if let empty = blocks.first!.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher2
                timeLabel.text = !(checkCollab()) ? "1:45 - 3:01" : "2:00 - 3:01"
            }
            else if checkDayZero() {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkCollab()) ? "1:45 - 3:01" : "2:00 - 3:01"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
            }
            
        default:
            print("Error")
        }
        
        
        
        
        
    }
    

    
    
    func setupBlocks() {
        
        blocks = getBlocks()
        
        if checkSemester() {
            
            blocks = getBlocks().filter { (b) -> Bool in
                b.semester == Int16(1)
            }
            
            semesterLabel.text = "Semester 1"
            
        } else {
            
            blocks = getBlocks().filter { (b) -> Bool in
                b.semester == Int16(2)
            }
            
            semesterLabel.text = "Semester 2"
            
        }
        
      
        switch blockSegment.selectedSegmentIndex {
            
        case 0:
            
            blocks = blocks.filter { (b) -> Bool in
                b.block == 1
            }
            
            if checkDayOne() {
                
                if let empty = blocks.first!.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                    }
                    
                        
                    } else {
                    classLabel.text  = "No Class"
                    
                    }
             
                teacherLabel.text = blocks.first!.nameTeacher
                timeLabel.text = !(checkCollab()) ? "8:40 - 10:00" : "8:40 - 9:45"
            }
            else if checkDayTwo() {
                if let empty = blocks.first!.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher2
                timeLabel.text = !(checkCollab()) ? "8:40 - 10:00" : "8:40 - 9:45"
            }
            else if checkDayZero() {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkCollab()) ? "8:40 - 10:00" : "8:40 - 9:45"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
            }
            
        case 1:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 2
            }
      
            
            if checkDayOne() {
                
                if let empty = blocks.first!.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                
                teacherLabel.text = blocks.first!.nameTeacher
                timeLabel.text = !(checkCollab()) ? "10:15 - 11:35": "11:00 - 12:05"
            }
            else if checkDayTwo() {
                if let empty = blocks.first!.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher2
                timeLabel.text = !(checkCollab()) ? "10:15 - 11:35": "11:00 - 12:05"
            }
            else if checkDayZero() {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkCollab()) ? "10:15 - 11:35": "11:00 - 12:05"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
            }
        case 2:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 3
            }
            
            
            if checkDayOne() {
                if let empty = blocks.first!.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher
                timeLabel.text = !(checkCollab()) ? "12:20 - 1:40" : "12:50 – 1:55"
            }
            else if checkDayTwo() {
                if let empty = blocks.first!.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher2
                timeLabel.text = !(checkCollab()) ? "12:20 - 1:40" : "12:50 – 1:55"
            }
            else if checkDayZero() {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkCollab()) ? "12:20 - 1:40" : "12:50 – 1:55"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
            }
        case 3:
            blocks = blocks.filter { (b) -> Bool in
                b.block == 4
            }
            
 
            
            if checkDayOne() {
                
                if let empty = blocks.first!.nameClass?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                
                teacherLabel.text = blocks.first!.nameTeacher
                timeLabel.text = !(checkCollab()) ? "1:45 - 3:01" : "2:00 - 3:01"
            }
            else if checkDayTwo() {
                if let empty = blocks.first!.nameClass2?.isEmpty {
                    
                    if empty {
                        
                        classLabel.text  = "No Class"
                        
                    } else {
                        classLabel.text = blocks.first!.nameClass2
                    }
                    
                    
                } else {
                    classLabel.text  = "No Class"
                    
                }
                teacherLabel.text = blocks.first!.nameTeacher2
                timeLabel.text = !(checkCollab()) ? "1:45 - 3:01" : "2:00 - 3:01"
            }
            else if checkDayZero() {
                classLabel.text = "No Class"
                teacherLabel.text = ""
                timeLabel.text = !(checkCollab()) ? "1:45 - 3:01" : "2:00 - 3:01"
            } else {
                classLabel.text = "No Class"
                timeLabel.text = "Enjoy your break!"
            }
            
           
            
            
            
            
            
            
            
            
        default:
            print("Error")
        }
        
    }
    
    
    func getBlocks() -> [Blocks] {
        
        do {
        let context = try persistenceManager.context.fetch(Blocks.fetchRequest()) as [Blocks]
        return context
        } catch {
            print(error)
            return [Blocks()]
        }
        
    }
    @IBAction func scheduleTapped(_ sender: Any) {
        
        if checkCollab() {
            setupCollab()
        } else {
            setupBlocks()
        }
        
    }
    
    @IBAction func segueTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "scheduleModuleSegue", sender: nil)
    }
    
    


}
