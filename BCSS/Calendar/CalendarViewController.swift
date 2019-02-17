//
//  CalendarViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-20.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    var events: [Event] = Event.eventsList
    var filtered: [Event]?

    let formatter = DateFormatter()

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var selectedDateLabel: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //select current date
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        
        
    
        
        //setting first month
        calendarView.visibleDates { (visibleDates) in
           self.setupLabels(from: visibleDates)
        }
    

        // Do any additional setup after loading the view.
    }
    
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
    
    func setupCalendar() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
    }
    
    func setupLabels (from visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        self.formatter.dateFormat = "MMMM yyyy"
        self.monthLabel.text = self.formatter.string(from: date)
        
        
    }
    
    func setupTextColor(cell: JTAppleCell?, cellState: CellState) {
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
    
    func setupSelection(cell: JTAppleCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else { return }
        if cellState.isSelected {
            
            calendarCell.selectedView.isHidden = false
            
        } else {
            calendarCell.selectedView.isHidden = true
        }
        
        
        
        
    }
    
    



}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
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

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let calendarCell =  cell as! CalendarCell
        sharedConfiguration(myCustomCell: calendarCell, cellState: cellState, date: date)
    
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let calendarCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        sharedConfiguration(myCustomCell: calendarCell, cellState: cellState, date: date)
        
        return calendarCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else { return }
        calendarCell.selectedView.isHidden = false
        setupTextColor(cell: calendarCell, cellState: cellState)
        
        formatter.dateFormat = "yyyy MM dd"
        
        filtered = events.filter({ (Event) -> Bool in
            return Event.date == formatter.string(from: date)
        })
        eventsTable.reloadData()
        
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else { return }
        calendarCell.selectedView.isHidden = true
        setupTextColor(cell: calendarCell, cellState: cellState)
        
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupLabels(from: visibleDates)
    }
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
   
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventSegue" {
            
            let eventInfoVC = segue.destination as! EventTableViewController
            
            guard let indexSelect = eventsTable.indexPathForSelectedRow?.row else {return}
            if let selected = filtered?[indexSelect] {
                eventInfoVC.eventNameString = selected.title
                eventInfoVC.eventDateString = selected.date
                
            }
            
            
      
            
        }
        
    }
    
    
    
    
    
}

