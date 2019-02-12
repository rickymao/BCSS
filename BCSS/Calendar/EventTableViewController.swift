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

    }

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }



}
