//
//  ServiceHoursInfoTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-17.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class ServiceHoursInfoTableViewController: UITableViewController {
    
    var name: String!
    var date: String!
    var hours: Double!
    var desc: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name!
        dateLabel?.text = "Date: \(date!)"
        hoursLabel?.text = String("Hours: \(hours!)")
        descText.text = desc

        
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descText: UITextView!
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    

}
