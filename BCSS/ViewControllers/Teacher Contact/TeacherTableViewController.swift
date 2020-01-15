//
//  TeacherTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2019-04-09.
//  Copyright © 2019 Treeline. All rights reserved.
//

import UIKit

class TeacherTableViewController: UITableViewController {
    
    var teachers: [Teacher] = []
    var department: Department?
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teachers.count
    }

   
}
