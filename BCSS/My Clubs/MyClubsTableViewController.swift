//
//  MyClubsTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-25.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class MyClubsTableViewController: UITableViewController {
    
    
    let persistenceManager = PersistenceManager.shared
    var myClubs: [Organization]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //Retrieve data
        do {
        myClubs = try persistenceManager.context.fetch(Organization.fetchRequest())
        
        } catch {
            print(error)
        }
        
        //Tableview background
        if myClubs?.count == 0 {
            self.tableView.backgroundView = background
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        
        if let vcs = self.navigationController?.viewControllers {
            if vcs.contains(where: { return $0 is MyFeedViewController
            }) {
                
                navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 0.612, green: 0.137, blue: 0.157, alpha: 100)
                
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 100)]
                
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Retrieve data
        do {
            myClubs = try persistenceManager.context.fetch(Organization.fetchRequest())
            
        } catch {
            print(error)
        }
        
        //Tableview background
        if myClubs?.count == 0 {
            self.tableView.backgroundView = background
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
        tableView.reloadData()
    }
    @IBOutlet var background: UIView!
    
    // MARK: - Table view data source
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myClubInfoSegue" {
            
            //Setup for club information
            if let info = segue.destination as? MyClubInfoTableViewController {
            
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
                
                    if let myClubs = myClubs?[index] {
                
                        info.nameTable = myClubs.name
                        info.teacherTable = myClubs.sponsor
                        info.dateTable = myClubs.meeting as [Date]
                        info.roomTable = myClubs.room
                        info.ownerTable = myClubs.leader
                        info.descTable = myClubs.descriptionClub
                        
                    }
                
                }
            }
        }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            //Deleting Clubs
            let deletedClub = indexPath.row
            if let deletedEntity = myClubs?[deletedClub] {
            
                myClubs?.remove(at: deletedClub)
                persistenceManager.context.delete(deletedEntity)
                persistenceManager.save()
                
                //Tableview background
                if myClubs?.count == 0 {
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myClubs?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clubCell = tableView.dequeueReusableCell(withIdentifier: "myClubCell", for: indexPath)
        
        // Configure the cell...
        let index = indexPath.row
        if let name = myClubs?[index].name {
            clubCell.textLabel?.text = "\(String(describing: name))"
        }
        return clubCell
        
    }
 
    
}
