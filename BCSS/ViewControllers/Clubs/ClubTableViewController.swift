//
//  ClubTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-18.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ClubTableViewController: UITableViewController {
    
    //OUTLETS
    @IBOutlet var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)

        //SETUP
        
        //Retrieve data
        getDatabase()

        //Sync data
        refClub.keepSynced(true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //SETUP
        
        //Retrieve Data
        clubs = []
        getDatabase()
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //setting up club info page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let clubInfoController = segue.destination as! InfoClubTableViewController
        
        if let myIndex = tableView.indexPathForSelectedRow?.row {
        clubInfoController.nameTable = "\(clubs[myIndex].name)"
        clubInfoController.teacherTable = "Sponsor: \(clubs[myIndex].teacher)"
        clubInfoController.dateTable = clubs[myIndex].meetingDates
        clubInfoController.roomTable = "\(clubs[myIndex].room)"
        clubInfoController.ownerTable = "Owners: \(clubs[myIndex].clubOwner)"
        clubInfoController.descTable = clubs[myIndex].description
        clubInfoController.emailTable = clubs[myIndex].email
        
        }
        
    
    }
    
    
    
    //Clubs
    
    //VARIABLES
    var dateFormat = DateFormatter()
    var clubs: [Club] = []
    let clubController = ClubModelController()
    let refClub = Database.database().reference(withPath: "clubKeyed")
    
    func createDate(hours: Int, minutes: Int, dayOfTheWeek: Int) -> Date {
        
        //Reminder - The week starts at 1 and goes to 7 (Sunday to Saturday)
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var date = DateComponents()
        date.weekday = dayOfTheWeek
        date.hour = hours
        date.minute = minutes
        
        let next = calendar.nextDate(after: Date(), matching: date, matchingPolicy: .strict)

        return next!
        
        
    }
    
    func getDatabase() {
        
        clubController.getClubCollection { (clubsDB) in
           
            if let newClubs = clubsDB {
                self.clubs = newClubs
                self.tableView.reloadData()
            } else {
                self.clubs = []
            }
        }

        
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clubs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clubCell", for: indexPath)

        // Configure the cell...
        let index = indexPath.row
        cell.textLabel?.text = "\(clubs[index].name)"
        cell.detailTextLabel?.text = "Sponsor Teacher: \(clubs[index].teacher)"

        return cell
    }
    
}
