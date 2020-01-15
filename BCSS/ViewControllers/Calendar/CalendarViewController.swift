//
//  CalendarViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-20.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseDatabase

class CalendarViewController: UIViewController {
    
    //VARIABLES
    var events: [Event] = []
    var filtered: [Event]?
    let formatter = DateFormatter()

    //OUTLETS
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet var footerView: UIView!
    
    let eventRef = Database.database().reference().child("calendarKeyed")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        setupCalendar()
        
        //Footerview
        eventsTable.tableFooterView = footerView
       
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //SETUP
        
        //select current date
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        
        //keep synced
        getDatabase()
        eventRef.keepSynced(true)
    
        
        //setting first month
        calendarView.visibleDates { (visibleDates) in
           self.setupLabels(from: visibleDates)
        }
    

        eventsTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let indexDeselect = eventsTable.indexPathForSelectedRow else {return}
        eventsTable.deselectRow(at: indexDeselect, animated: true)
        
        
    }
    

    
    //Retrieving Event Data for today
    func getDatabase() {
        
        let date = Date()
        let eventController = EventModelController()
        
        eventController.getEventCollection { (eventsDB) in
            if let newEvents = eventsDB {
                
                self.events = newEvents
                self.filtered = self.events.filter({ (Event) -> Bool in
                    return Event.date == self.formatter.string(from: date)
                })
                self.eventsTable.reloadData()
            }
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
    

    
    //UI setup for calendar linespacing, text, and labels
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
    
    //Setting highlight on date tap
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
        let startDate = formatter.date(from: "09/01/2019")
        let endDate = formatter.date(from: "09/01/2030")
        
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
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        guard let calendarCell = cell as? CalendarCell else { return }
        calendarCell.selectedView.isHidden = false
        setupTextColor(cell: calendarCell, cellState: cellState)
        
        formatter.dateFormat = "yyyy MM dd"
        filtered = events.filter({ (Event) -> Bool in
            return Event.date == formatter.string(from: date)
        })
        eventsTable.reloadData()
        
        
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
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
    
    //Sends event data to info viewcontroller
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
