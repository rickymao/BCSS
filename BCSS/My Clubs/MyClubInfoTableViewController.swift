//
//  MyClubInfoTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-07.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class MyClubInfoTableViewController: UITableViewController {
    
    let persistenceManager = PersistenceManager.shared
    
    var nameTable: String = ""
    var ownerTable: String = ""
    var teacherTable: String = ""
    var roomTable: String = ""
    var dateTable: [Date] = []
    var descTable: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //Setting text
        let dateFormat = DateFormatter()
        var meetingLoop: String = String()
        dateFormat.dateFormat = "E HH:mm"
        
        for date in dateTable {
            
            
            let dateString = dateFormat.string(from: date)
            
            
            if dateTable.last == date {
                
                meetingLoop += dateString + ""
                
            } else {
                meetingLoop += dateString + ", "
            }
            
        }
        
        
   
        clubName.text = nameTable
        Leader.text = ownerTable
        Sponsor.text = teacherTable
        Room.text = roomTable
        meetingDate.text = meetingLoop
        
        Description.text = descTable
        
        
    }
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
