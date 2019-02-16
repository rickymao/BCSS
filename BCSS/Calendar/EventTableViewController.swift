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
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        eventName.text = eventNameString
        eventDate.text = eventDateString

    }

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    var eventNameString: String?
    var eventDateString: String?

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }



}
