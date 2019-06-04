//
//  EventTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2019-02-11.
//  Copyright © 2019 Treeline. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.bounces = true
        eventName.text = eventNameString
        eventDate.text = eventDateString
        if let eventLocalStr = eventLocationString {
            
            eventLocation.text = eventLocalStr
        }
        if let eventTimeStr = eventTimeString {
            
            eventTime.text = eventTimeStr
        }
        eventDesc.text = eventDescString
        
    }

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDesc: UITextView!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    var eventDescString: String?
    var eventTimeString: String?
    var eventNameString: String?
    var eventDateString: String?
    var eventLocationString: String?
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

}
