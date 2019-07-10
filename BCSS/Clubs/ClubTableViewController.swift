//
//  ClubTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-18.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ClubTableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)

        //Retrieve data
        getDatabase()
        
        
        //Sync data
        refClub.keepSynced(true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    var dateFormat = DateFormatter()
    var clubs: [Club] = []
    
    let refClub = Database.database().reference(withPath: "clubKeyed")
    
    func createDate(hours: Int, minutes: Int, dayOfTheWeek: Int) -> Date {
        
        //Reminder - The week starts at 1 to 7 (Sunday to Saturday)
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var date = DateComponents()
        date.weekday = dayOfTheWeek
        date.hour = hours
        date.minute = minutes
        
        let next = calendar.nextDate(after: Date(), matching: date, matchingPolicy: .strict)

        return next!
        
        
    }
    
    func getDatabase() {
        
        
        let ref = Database.database().reference()
        
        ref.child("clubKeyed").observeSingleEvent(of: .value) { (snapshot) in
            
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    let club = snapshotJSON.childSnapshot(forPath: "Club").value as! String
                    let owner = snapshotJSON.childSnapshot(forPath: "Owner").value as! String
                    let room = snapshotJSON.childSnapshot(forPath: "Room").value as! String
                    let teacher = snapshotJSON.childSnapshot(forPath: "Teacher").value as! String
                    let description = snapshotJSON.childSnapshot(forPath: "Description").value as! String
                    let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
                    let hours = snapshotJSON.childSnapshot(forPath: "Hours").value as! String
                    let minutes = snapshotJSON.childSnapshot(forPath: "Minutes").value as! String
                    let dayOfWeek = snapshotJSON.childSnapshot(forPath: "DayofWeek").value as! String
                    
                    if let hoursInt = Int(hours), let minutesInt = Int(minutes), let dayOfWeekInt = Int(dayOfWeek) {
                        
                        let newClub = Club(name: club, teacher: teacher, meeting: [self.createDate(hours: hoursInt, minutes: minutesInt, dayOfTheWeek: dayOfWeekInt)], room: room, owner: owner, desc: description, email: [email])
                        
                        
                            //Adding to array
                            self.clubs.append(newClub)
                    
                    
                        
                    }
                    
                    
                    
                }
                
                
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    func update() {
        

        
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
