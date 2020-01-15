//
//  MyTeamInfoTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-08.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

class MyTeamInfoTableViewController: UITableViewController {
    
    //Variables
    var teamName: String = String()
    var coach: String = String()
    var sponsor: String = String()
    var season: String = String()
    var practice: Date = Date()
    var grades: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //Initializing team information
        let dateFormat = DateFormatter()
        teamLabel.text = teamName
        coachLabel.text = coach
        sponsorLabel.text = sponsor
        seasonLabel.text = season
        gradesLabel.text = grades
        practiceLabel.text = dateFormat.string(from: practice)

    }

    //Outlets
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var coachLabel: UILabel!
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var gradesLabel: UILabel!
    @IBOutlet weak var practiceLabel: UILabel!
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    

   
}
