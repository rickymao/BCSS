//
//  ClubModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class ClubModuleViewController: UIViewController {
    
    let persistenceManager = PersistenceManager.shared
    let formatter = DateFormatter()
    
    var meetings: [Organization] = []
    var filteredMeetings: [Organization] = []
    var currentMeetings: [Organization] = []

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Observer
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        //round corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true

        // Do any additional setup after loading the view.
        
        do {
        let clubs = try persistenceManager.context.fetch(Organization.fetchRequest()) as [Organization]
       
            meetings = clubs

            
        } catch {
                print(error)
            }
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        do {
            let clubs = try persistenceManager.context.fetch(Organization.fetchRequest()) as [Organization]
          
            
            meetings = clubs
        
            
        } catch {
            print(error)
        }
        
        filteredMeetings = sortTimes(meetings: meetings)
        setupTimes()
        
        if filteredMeetings.count == 0 {
            meetingsTable.backgroundView = background
            meetingsTable.separatorStyle = .none
        }  else {
            meetingsTable.backgroundView = nil
            meetingsTable.separatorStyle = .singleLine
        }
        
        meetingsTable.reloadData()
        
    }
    
    @IBOutlet weak var timeSegment: UISegmentedControl!
    @IBOutlet weak var meetingsTable: UITableView!
    @IBOutlet var background: UIView!
    
    
    @IBAction func segmentTapped(_ sender: Any) {
        
        filteredMeetings = sortTimes(meetings: meetings)
        print(filteredMeetings)
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
        
        do {
            let clubs = try persistenceManager.context.fetch(Organization.fetchRequest()) as [Organization]
            
            
            meetings = clubs
           
            
        } catch {
            print(error)
        }
        
        filteredMeetings = sortTimes(meetings: meetings)
        setupTimes()
        
        if filteredMeetings.count == 0 {
            meetingsTable.backgroundView = background
            meetingsTable.separatorStyle = .none
        }  else {
            meetingsTable.backgroundView = nil
            meetingsTable.separatorStyle = .singleLine
        }
        
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
                
                let dates = org.meeting
                var isCurrent = false
                
                dateLoop: for date in dates {
                    
                    var component = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: date as Date)
                    component.year = 2018
                    component.month = 9
                    let componentTime = calendar.date(from: component)
                    
                    let componentMeetDay = calendar.dateComponents([Calendar.Component.weekday], from: date as Date)
                    let componentsMeet = DateComponents(calendar: calendar, year: 2018, month: 9, weekday: 1)
                    let dateMeet = calendar.date(from: componentsMeet)
                    
                    let componentDateMeet = calendar.nextDate(after: dateMeet!, matching: componentMeetDay, matchingPolicy: .strict)
                    
                    
                    
                    let component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
                    
                    
                    
                    if componentTime! < dateNoon! && calendar.date(componentDateMeet!, matchesComponents: component2) {
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
                    
                    var component = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: date as Date)
                    component.year = 2018
                    component.month = 9
                    let componentTime = calendar.date(from: component)
                    
                    let componentMeetDay = calendar.dateComponents([Calendar.Component.weekday], from: date as Date)
                    let componentsMeet = DateComponents(calendar: calendar, year: 2018, month: 9, weekday: 1)
                    let dateMeet = calendar.date(from: componentsMeet)
                    
                    let componentDateMeet = calendar.nextDate(after: dateMeet!, matching: componentMeetDay, matchingPolicy: .strict)
                    
              
                    
                    let component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
       
                 

                    if componentTime! == dateNoon! && calendar.date(componentDateMeet!, matchesComponents: component2) {
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
                    
                    var component = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: date as Date)
                    component.year = 2018
                    component.month = 9
                    let componentTime = calendar.date(from: component)
                    
                    let componentMeetDay = calendar.dateComponents([Calendar.Component.weekday], from: date as Date)
                    let componentsMeet = DateComponents(calendar: calendar, year: 2018, month: 9, weekday: 1)
                    let dateMeet = calendar.date(from: componentsMeet)
                    
                    let componentDateMeet = calendar.nextDate(after: dateMeet!, matching: componentMeetDay, matchingPolicy: .strict)
                    
                    
                    
                    let component2 = calendar.dateComponents([Calendar.Component.weekday], from: Date())
                    
                    
                    
                    if componentTime! > dateNoon! && calendar.date(componentDateMeet!, matchesComponents: component2) {
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
    
    //implement this
    @IBAction func segueTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "clubModuleSegue", sender: nil)
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



