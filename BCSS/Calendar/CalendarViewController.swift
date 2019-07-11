//
//  CalendarViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-20.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseDatabase

class CalendarViewController: UIViewController {
    
    var events: [Event] = []
    var filtered: [Event]?

    let formatter = DateFormatter()

    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet var footerView: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTable.reloadData()
        setupCalendar()
        eventsTable.tableFooterView = footerView
       
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //select current date
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        
        //Retrieve Data
        getDatabase()
    
        
        //setting first month
        calendarView.visibleDates { (visibleDates) in
           self.setupLabels(from: visibleDates)
        }
    

        // Do any additional setup after loading the view.
    }
    
    //Retrieving Data
    func getDatabase() {
        
        let ref = Database.database().reference()
        
        
        ref.child("calendarKeyed").observe(.value) { (snapshots) in
            
            
            
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

                    
                    self.events.append(Event(title: title, date: date, location: location, description: description, time: time))
                    
                    
                }
                
                
            }
            self.eventsTable.reloadData()
        }
        
        
        
    }
    
    //Refreshing UI
    override func willMove(toParent parent: UIViewController?) {
        
        if let vcs = self.navigationController?.viewControllers {
            if vcs.contains(where: { return $0 is MyFeedViewController
            }) {
                
                navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 0.612, green: 0.137, blue: 0.157, alpha: 100)
                
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 100)]
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let indexDeselect = eventsTable.indexPathForSelectedRow else {return}
        eventsTable.deselectRow(at: indexDeselect, animated: true)
    }
    
    //UI Setup
    func setupCalendar() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
    }
    
    func setupLabels (from visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "MMMM yyyy"
        self.monthLabel.text = self.formatter.string(from: date)
        
        
    }
    
    func setupTextColor(cell: JTACDayCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else { return }
        
        if cellState.isSelected {
            calendarCell.dateLabel.textColor = UIColor.white
    
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                calendarCell.dateLabel.textColor = UIColor.darkGray
            } else {
                calendarCell.dateLabel.textColor = UIColor.lightGray
            }
        }
        
        
    }
    
    func setupSelection(cell: JTACDayCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else { return }
        if cellState.isSelected {
            
            calendarCell.selectedView.isHidden = false
            
        } else {
            calendarCell.selectedView.isHidden = true
        }
        
        
        
        
    }
    
    



}

extension CalendarViewController: JTACMonthViewDelegate {
    
    //Setting up calendar
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        //Setup Dates
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "09/04/2018")
        let endDate = formatter.date(from: "09/30/2019")
        
        if let start = startDate, let end = endDate {
            let parameter = ConfigurationParameters(startDate: start, endDate: end)
            
            return parameter
            
        } else {
            
        return ConfigurationParameters(startDate: Date(), endDate: Date())
            
        }
        
        
    }
    
    func sharedConfiguration (myCustomCell: CalendarCell, cellState: CellState, date: Date) {
        
        
        
        let today = Date()
        formatter.dateFormat = "yyyy MM dd"
        let todayString = formatter.string(from: today)
        let dateString = formatter.string(from: cellState.date)
        
        if todayString == dateString {
            myCustomCell.currentView.isHidden = false
        } else {
            myCustomCell.currentView.isHidden = true
            
        }
        
        
        myCustomCell.dateLabel.text = cellState.text
        setupSelection(cell: myCustomCell, cellState: cellState)
        setupTextColor(cell: myCustomCell, cellState: cellState)
        
        
        
    }
    
}

extension CalendarViewController: JTACMonthViewDataSource {
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let calendarCell =  cell as! CalendarCell
        sharedConfiguration(myCustomCell: calendarCell, cellState: cellState, date: date)
    
    }
    
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let calendarCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        sharedConfiguration(myCustomCell: calendarCell, cellState: cellState, date: date)
        
        return calendarCell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else { return }
        calendarCell.selectedView.isHidden = false
        setupTextColor(cell: calendarCell, cellState: cellState)
        
        formatter.dateFormat = "yyyy MM dd"
        
        filtered = events.filter({ (Event) -> Bool in
            return Event.date == formatter.string(from: date)
        })
        eventsTable.reloadData()
        
        
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else { return }
        calendarCell.selectedView.isHidden = true
        setupTextColor(cell: calendarCell, cellState: cellState)
        
        
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupLabels(from: visibleDates)
    }
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        if let index = filtered?[indexPath.row] {
            eventCell.textLabel?.text = index.title
        }
        
        return eventCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered?.count ?? 0
    }
    
    //Sends data to info viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dateFormat = DateFormatter()
        
        if segue.identifier == "eventSegue" {
            
            
            let eventInfoVC = segue.destination as! EventTableViewController
            
            guard let indexSelect = eventsTable.indexPathForSelectedRow?.row else {return}
            
            
            
            if let selected = filtered?[indexSelect] {
                
                
                var convertedDate: String = String()
      
                eventInfoVC.eventNameString = selected.title
                eventInfoVC.eventTimeString = selected.time
                eventInfoVC.eventLocationString = selected.location
                eventInfoVC.eventDescString = selected.description
                
          
            
                
                dateFormat.dateFormat = "yyyy mm dd"
                if let date = dateFormat.date(from: selected.date) {
                    dateFormat.dateFormat = "EEEE, MMM d, yyyy"
                    convertedDate = dateFormat.string(from: date)
               
                }
            
                
                eventInfoVC.eventDateString = convertedDate
                
              }
            }
            
            
      
            
        }
        
    
    

    
}
