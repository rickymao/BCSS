//
//  SportsTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-19.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SportsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.820, green: 0.114, blue: 0.165, alpha: 100)

        //Retrieve Data
        getDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sports
    let dateFormat = DateFormatter.init()
    var sports: [Sports] = []
    
    func getDatabase() {
        
        let ref = Database.database().reference()
        
        ref.child("sportKeyed").observe(.value) { (snapshot) in
            
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    let name = snapshotJSON.childSnapshot(forPath: "Name").value as! String
                    let coach = snapshotJSON.childSnapshot(forPath: "Coach").value as! String
                    let teacher = snapshotJSON.childSnapshot(forPath: "Teacher").value as! String
                    let season = snapshotJSON.childSnapshot(forPath: "Season").value as! String
                    let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String

                        //Adding to array
                        self.sports.append(Sports(name: name, coach: coach, teacher: teacher, season: season, email: email))
                    
                }
                
                
            }
            self.tableView.reloadData()
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let infoSportController = segue.destination as! InfoSportsTableViewController
        if let index = tableView.indexPathForSelectedRow?.row {
        let currentSport = sports[index]

        
        //Setting up text
        infoSportController.teamString = currentSport.name
        infoSportController.coachString = currentSport.coach
        infoSportController.seasonString = currentSport.season
        infoSportController.sponsorString = currentSport.teacher
        infoSportController.emailString = currentSport.email
            
        
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sports.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sportCell", for: indexPath)
        
        let index = indexPath.row
        cell.textLabel?.text = "\(sports[index].name) Team"
        return cell
    }

}
