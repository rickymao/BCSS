//
//  MyTeamTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-08.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class MyTeamTableViewController: UITableViewController {
    
    let persistenceManager = PersistenceManager.shared
    var myTeams: [Team]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //Setup teams
        do {
            let fetchTeams = try persistenceManager.context.fetch(Team.fetchRequest()) as? [Team]
            myTeams = fetchTeams
            
        } catch {
            print(error)
        }
        
        //Tableview background
        if myTeams?.count == 0 {
            self.tableView.backgroundView = background
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Setup teams
        do {
            let fetchTeams = try persistenceManager.context.fetch(Team.fetchRequest()) as? [Team]
            myTeams = fetchTeams
            
        } catch {
            print(error)
        }
        
        
        //Tableview background
        if myTeams?.count == 0 {
            self.tableView.backgroundView = background
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
    }

    @IBOutlet var background: UIView!
    
    // MARK: - Table view data source
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myTeamInfoSegue" {
            
            let info = segue.destination as! MyTeamInfoTableViewController
            
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            if let chosenTeam = myTeams?[index] {
                
                info.teamName = chosenTeam.sport
                info.coach = chosenTeam.coach
                info.sponsor = chosenTeam.teacher
                info.season = chosenTeam.season
                info.grades = chosenTeam.grade
                info.practice = chosenTeam.practiceTime as Date
            
            }
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myTeams?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTeamCell", for: indexPath)
        if let myTeams = myTeams?[indexPath.row] {
        cell.textLabel?.text = myTeams.sport
            
        
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let deletedTeam = indexPath.row
            if let deleteEntity = myTeams?[deletedTeam] {
                
                myTeams?.remove(at: deletedTeam)
                persistenceManager.context.delete(deleteEntity)
                persistenceManager.save()
                
                //Tableview background
                if myTeams?.count == 0 {
                    self.tableView.backgroundView = background
                    self.tableView.separatorStyle = .none
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .singleLine
                }
                
                tableView.reloadData()
                
            }
            
            
        }
    }

 

}
