//
//  ClubModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClubModuleViewController: UIViewController {
    
    //Variables
    let persistenceManager = PersistenceManager.shared
    let formatter = DateFormatter()
    var meetings: [Organization] = []
    var filteredMeetings: [Organization] = []
    var currentMeetings: [Organization] = []
    var val: Bool = false

    

    //View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Observer
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        //round corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true

        // Do any additional setup after loading the view.
        clubSetup()
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Update
        clubSetup()
        meetingsTable.reloadData()
        
    }
    
    
    
    //Outlets
    @IBOutlet weak var timeSegment: UISegmentedControl!
    @IBOutlet weak var meetingsTable: UITableView!
    @IBOutlet var background: UIView!
    
    
    @IBAction func segmentTapped(_ sender: Any) {
        
        //Finds today's meetings and checks if view needs to be set to empty
        dataSetup()
        
        if filteredMeetings.count == 0 {
            meetingsTable.backgroundView = background
            meetingsTable.separatorStyle = .none
        } else {
            meetingsTable.backgroundView = nil
             meetingsTable.separatorStyle = .singleLine
        }

        
    }
    
    @objc func willEnterForeground() {
        
        //Update
       clubSetup()
        meetingsTable.reloadData()
        
        
    }
    
    func setupTimes() {
        
        filteredMeetings = sortTimes(meetings: meetings)

        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.hour = 11
        components.minute = 35
        components.year = 2018
        components.month = 9
        
        let dateNoon = calendar.date(from: components)
        switch timeSegment.selectedSegmentIndex {
            
        case 0:
         
            filteredMeetings = filteredMeetings.filter({ (org) -> Bool in
                
                //Setting base date to compare
                let dates = org.meeting
                var isCurrent = false
                
                dateLoop: for date in dates {
                    
                    
                    let componentTime = getClubMeetingTime(date: date as Date)
                    
                    let componentDateMeet = reformattedMeetDate(date: date as Date)
                    
                    //Today's weekday component
                    let component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
                
                    
                    //Checking for morning meetings on matching weekdays
                    if componentTime < dateNoon! && calendar.date(componentDateMeet, matchesComponents: component2) && val {
                        isCurrent = true
                        break dateLoop
                        
                    } else {
                        isCurrent = false
                    }
                    
                }
                return isCurrent
            })
            
            self.getBackground()
            
            meetingsTable.reloadData()
            
            
            
        case 1:
           
            filteredMeetings = filteredMeetings.filter({ (org) -> Bool in
                
                let dates = org.meeting
                var isCurrent = false
                
                dateLoop: for date in dates {
                    
                    let componentTime = getClubMeetingTime(date: date as Date)
                    let componentDateMeet = reformattedMeetDate(date: date as Date)
                    
                    //Today's weekday component
                    let component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
       
                 

                    if componentTime == dateNoon! && calendar.date(componentDateMeet, matchesComponents: component2) && val {
                        isCurrent = true
                        break dateLoop
                        
                    } else {
                        isCurrent = false
                    }
                    
                }
                return isCurrent
            })
            
            self.getBackground()
           
            meetingsTable.reloadData()
            
            
            
           
           
        case 2:
            
          
            filteredMeetings = filteredMeetings.filter({ (org) -> Bool in
                
                let dates = org.meeting
                var isCurrent = false
                
                dateLoop: for date in dates {
                    
                    let componentTime = getClubMeetingTime(date: date as Date)
                    let componentDateMeet = reformattedMeetDate(date: date as Date)
                    
                    //Today's weekday component
                    let component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
                    
                    
                    
                    if componentTime > dateNoon! && calendar.date(componentDateMeet, matchesComponents: component2) && val {
                        isCurrent = true
                        break dateLoop
                        
                    } else {
                        isCurrent = false
                    }
                    
                }
                return isCurrent
            })
            
            self.getBackground()
            
            meetingsTable.reloadData()
            
            
            
            
        default:
            print("Error")
        }
    }
    
        
        

    //Checks and returns the club meetings of that day
    func sortTimes(meetings: [Organization]) -> [Organization] {
        
        return meetings.filter({ (org) -> Bool in
            
            let dates = org.meeting
            var isCurrent = false
            let calendar = Calendar.current
            
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
    
    func getClubMeetingTime(date: Date) -> Date {
        
        let calendar = Calendar.current
        
        //Club meeting time
        var component = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: date as Date)
        component.year = 2018
        component.month = 9
       
        guard let componentTime = calendar.date(from: component) else {return Date()}
        
        
        return componentTime
    }
    
    func reformattedMeetDate(date: Date) -> Date {
        
        let calendar = Calendar.current
        
        //Reformatted meeting date
        let componentWeekDay = calendar.dateComponents([Calendar.Component.weekday], from: date as Date)
        let componentsMeet = DateComponents(calendar: calendar, year: 2018, month: 9, weekday: 1)
        let dateMeet = calendar.date(from: componentsMeet)
        
        //Club weekday
        guard let componentDateMeet = calendar.nextDate(after: dateMeet!, matching: componentWeekDay, matchingPolicy: .strict) else {return Date()}
        
        return componentDateMeet
    }
    
    func clubSetup() {
        
        //Retrieve Coredata objects
        do {
            let clubs = try persistenceManager.context.fetch(Organization.fetchRequest()) as [Organization]
            
            meetings = clubs
            
        } catch {
            print(error)
        }
        
        //Setup the data
        dataSetup()
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "clubInfoSegue" {
            
            let vc = segue.destination as? InfoClubTableViewController
            
            if let index = meetingsTable.indexPathForSelectedRow?.row {
                
                vc?.nameTable = filteredMeetings[index].name
                vc?.ownerTable = filteredMeetings[index].leader
                vc?.teacherTable = filteredMeetings[index].sponsor
                vc?.roomTable = filteredMeetings[index].room
                vc?.dateTable = filteredMeetings[index].meeting as [Date]
                vc?.descTable = filteredMeetings[index].descriptionClub
                
            } else {
                
                
                
            }
            
        }
    }
    
    func getBackground() {
        
        //Set empty background
        if filteredMeetings.count == 0 {
            meetingsTable.backgroundView = background
            meetingsTable.separatorStyle = .none
        } else {
            meetingsTable.backgroundView = nil
            meetingsTable.separatorStyle = .singleLine
        }
    }
    
    func dataSetup() {
        
        var events: [Event] = []
        
        Database.database().reference().child("calendarKeyed").observeSingleEvent(of: .value) { (snapshot) in

            for snapshot in snapshot.children {

                var title: String
                var date: String
                var location: String
                var description: String
                var time: String


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
                    
                    self.formatter.dateFormat = "yyyy MM dd"
                    let today = self.standardizeDate(dateInput: Date())
                    if let eventDate = self.formatter.date(from: date) {
                        
                        if today == eventDate {
                            
                            events.append(Event(title: title, date: date, location: location, description: description, time: time))

                        }
                        
                    }
                    
                    


                }
            }
            
            
            
            for event in events  {
                
                if event.title == "Day 1" || event.title == "Day 2" {
                    self.val = true
                    break
                } else {
                    self.val = false
                    
                }
                
            }
            
            //Complete other setup
            
            self.setupTimes()
            
            
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



extension ClubModuleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMeetings.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meetDates = meetingsTable.dequeueReusableCell(withIdentifier: "meetingCells", for: indexPath)
        
        meetDates.textLabel?.text = filteredMeetings[indexPath.row].name
        
        return meetDates
    }
    
    
}



