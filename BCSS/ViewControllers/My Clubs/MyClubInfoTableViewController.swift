//
//  MyClubInfoTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-07.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

class MyClubInfoTableViewController: UITableViewController {
    
    //VARIABLES
    let persistenceManager = PersistenceManager.shared
    var nameTable: String = ""
    var ownerTable: String = ""
    var teacherTable: String = ""
    var roomTable: String = ""
    var dateTable: [Date] = []
    var descTable: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Setting text colours nav-bar
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //SETUP
        
        //Setting meeting dates
        let dateFormat = DateFormatter()
        var meetingLoop: String = String()
        dateFormat.dateFormat = "E HH:mm"
        
        //List out meeting dates in list format
        for date in dateTable {
            
            let dateString = dateFormat.string(from: date)
            
            if dateTable.last == date {
                
                meetingLoop += dateString + ""
                
            } else {
                meetingLoop += dateString + ", "
            }
            
        }
        
        
   //Initializing user's club information
        clubName.text = nameTable
        Leader.text = ownerTable
        Sponsor.text = teacherTable
        Room.text = roomTable
        meetingDate.text = meetingLoop
        
        Description.text = descTable
        
        
    }
    
    //OUTLETS
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var Leader: UILabel!
    @IBOutlet weak var Sponsor: UILabel!
    @IBOutlet weak var Room: UILabel!
    @IBOutlet weak var meetingDate: UILabel!
    @IBOutlet weak var Description: UITextView!
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    
}
