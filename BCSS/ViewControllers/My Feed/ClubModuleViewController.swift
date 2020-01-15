//
//  ClubModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClubModuleViewController: UIViewController {
    
    //VARIABLES
    let persistenceManager = PersistenceManager.shared
    let formatter = DateFormatter()
    var meetings: [CoreClub] = []
    var filteredMeetings: [CoreClub] = []
    var currentMeetings: [CoreClub] = []
    var isSchoolDay: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //rounding corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
        
        //Observer
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        //SETUP
        
        //Get current clubs from the database
        clubSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Get current clubs from the database
        clubSetup()
        
        
    }
    
    
    
    //OUTLETS
    @IBOutlet weak var timeSegment: UISegmentedControl!
    @IBOutlet weak var meetingsTable: UITableView!
    @IBOutlet var background: UIView!
    
    
    //Triggered when tapping on the tabs of the club module
    @IBAction func segmentTapped(_ sender: Any) {
        
        //Finds today's meetings
        setupMeetings()
        
        //checks if view needs to be set to empty
        getBackground()
        
    }
    
    @objc func willEnterForeground() {
        
        //Get current clubs from the database
       clubSetup()
        
        
    }
    
    //Setup and organize the meetings in terms of time of day (e.g. Morning)
    func setupMeetings() {
        
        //Checking if today is a school day
        let dateController = DateController()
        dateController.checkSchoolDay { (Bool) in
            self.isSchoolDay = Bool
        }
        
        //Grabs today's meetings
        let clubController = ClubModelController()
        filteredMeetings = clubController.getTodaysClubMeetings(meetings: meetings)

        //Setup calendar components for lunch meetings
        //Each meeting will be in terms of morning, lunch, or afternoon
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = DateComponents()
        components.hour = 11
        components.minute = 35
        components.year = 2018
        components.month = 9
        let dateNoon = calendar.date(from: components)
        
        //Depending on the morning, lunch, or afternoon tabs users tap on, different club meetings will show up for the respective times
        switch timeSegment.selectedSegmentIndex {
            
            //Morning
        case 0:
         
            filteredMeetings = filteredMeetings.filter({ (org) -> Bool in
                
                //Setting base date to compare
                let dates = org.meeting
                var isCurrent = false
                
                dateLoop: for date in dates {
                    
                    //Formatting dates
                    let componentTime = getClubMeetingTime(date: date as Date)
                    let componentDateMeet = reformattedMeetDate(date: date as Date)
                    
                    //Today's weekday component
                    let component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
                
                    
                    //Checking for morning meetings on matching weekdays
                    if componentTime < dateNoon! && calendar.date(componentDateMeet, matchesComponents: component2) && isSchoolDay {
                        isCurrent = true
                        break dateLoop
                        
                    } else {
                        isCurrent = false
                    }
                    
                }
                return isCurrent
            })
            
            //Checks if view is empty and setting the background to blank if so
            self.getBackground()
            
            meetingsTable.reloadData()
            
            
            //Noon
        case 1:
           print(filteredMeetings)
            filteredMeetings = filteredMeetings.filter({ (org) -> Bool in
                
                let dates = org.meeting
                var isCurrent = false
                
                dateLoop: for date in dates {
                    
                    //Formatting dates
                    let componentTime = getClubMeetingTime(date: date as Date)
                    let componentDateMeet = reformattedMeetDate(date: date as Date)
                    
                    //Today's weekday component
                    let component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
       

                    //Checking if the meeting occurs during lunch
                    if componentTime == dateNoon! && calendar.date(componentDateMeet, matchesComponents: component2) && isSchoolDay {
                       
                        isCurrent = true
                        break dateLoop
                        
                    } else {
                        print(isSchoolDay)
                        isCurrent = false
                    }
                    
                }
                return isCurrent
            })
            print(filteredMeetings)
            //Checks if view is empty and setting the background to blank if so
            self.getBackground()
           
            meetingsTable.reloadData()
            
            //Afternoon
        case 2:
            
            filteredMeetings = filteredMeetings.filter({ (org) -> Bool in
                
                let dates = org.meeting
                var isCurrent = false
                
                dateLoop: for date in dates {
                    
                    //Formatting date
                    let componentTime = getClubMeetingTime(date: date as Date)
                    let componentDateMeet = reformattedMeetDate(date: date as Date)
                    
                    //Today's weekday component
                    let component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
                    
                    
                    
                    if componentTime > dateNoon! && calendar.date(componentDateMeet, matchesComponents: component2) && isSchoolDay {
                        isCurrent = true
                        break dateLoop
                        
                    } else {
                        isCurrent = false
                    }
                    
                }
                return isCurrent
            })
            
            //Checks if view is empty and setting the background to blank if so
            self.getBackground()
            
            meetingsTable.reloadData()

            
        default:
            print("Error")
        }
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
        
        //Retrieve Core Data objects
        let clubController = ClubModelController()
        meetings = clubController.getMyClubCollection()
        
        //Setup the data
        setupMeetings()
        
        //Update the meetings tableview
        meetingsTable.reloadData()
        
        
    }
    
    //Segue to club's info
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
    
    //Sets background empty when there are no clubs
    func getBackground() {
        
        if filteredMeetings.count == 0 {
            meetingsTable.backgroundView = background
            meetingsTable.separatorStyle = .none
        } else {
            meetingsTable.backgroundView = nil
            meetingsTable.separatorStyle = .singleLine
        }
    }
    
    
}

//Load the tableview with club meetings
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



