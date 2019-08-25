//
//  ClubModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class ClubModuleViewController: UIViewController {
    
    //Variables
    let persistenceManager = PersistenceManager.shared
    let formatter = DateFormatter()
    var meetings: [Organization] = []
    var filteredMeetings: [Organization] = []
    var currentMeetings: [Organization] = []

    

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
        filteredMeetings = sortTimes(meetings: meetings)
        setupTimes()
        
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
                    if componentTime < dateNoon! && calendar.date(componentDateMeet, matchesComponents: component2) && checkSchoolDay() {
                        isCurrent = true
                        break dateLoop
                        
                    } else {
                        isCurrent = false
                    }
                    
                }
                return isCurrent
            })
            
            
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
       
                 

                    if componentTime == dateNoon! && calendar.date(componentDateMeet, matchesComponents: component2) && checkSchoolDay() {
                        isCurrent = true
                        break dateLoop
                        
                    } else {
                        isCurrent = false
                    }
                    
                }
                return isCurrent
            })
            
           
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
                    
                    
                    
                    if componentTime > dateNoon! && calendar.date(componentDateMeet, matchesComponents: component2) && checkSchoolDay() {
                        isCurrent = true
                        break dateLoop
                        
                    } else {
                        isCurrent = false
                    }
                    
                }
                return isCurrent
            })
            
            
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
        
        //Finds today
        filteredMeetings = sortTimes(meetings: meetings)
        setupTimes()
        
        //Set empty background
        if filteredMeetings.count == 0 {
            meetingsTable.backgroundView = background
            meetingsTable.separatorStyle = .none
        } else {
            meetingsTable.backgroundView = nil
            meetingsTable.separatorStyle = .singleLine
        }
        
        
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
    
    func checkSchoolDay() -> Bool {
        
        let vc = UIStoryboard(name: "MyFeed", bundle: nil).instantiateViewController(withIdentifier: "EventsModuleViewController") as? EventsModuleViewController
        
        var val: Bool = false
        
        guard let events = vc?.filteredEvents else {return false}

        for event in events  {
            
            if event.title == "Day 1" || event.title == "Day 2" {
                val = true
                break
            } else {
                val = false
                
            }
            
        }
        return val
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



