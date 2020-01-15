//
//  EventTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2019-02-11.
//  Copyright © 2019 Ricky Mao. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //SETUP
        
        //Initializes event information
        tableView.bounces = true
        eventName?.text = eventNameString
        eventDate?.text = eventDateString
        eventLocation?.text = eventLocationString
        eventTime?.text = eventTimeString
        eventDesc?.text = eventDescString
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

    }

    //OUTLETS
    @IBOutlet weak var eventName: UILabel?
    @IBOutlet weak var eventDate: UILabel?
    @IBOutlet weak var eventDesc: UITextView?
    @IBOutlet weak var eventTime: UILabel?
    @IBOutlet weak var eventLocation: UILabel?
    
    //VARIABLES
    var eventDescString: String!
    var eventTimeString: String!
    var eventNameString: String!
    var eventDateString: String!
    var eventLocationString: String!
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

}
