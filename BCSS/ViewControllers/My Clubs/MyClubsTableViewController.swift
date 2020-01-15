//
//  MyClubsTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-25.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

class MyClubsTableViewController: UITableViewController {
    
    //VARIABLES
    let persistenceManager = PersistenceManager.shared
    var myClubs: [CoreClub]?
    let clubController = ClubModelController()
    
    //OUTLETS
    @IBOutlet var background: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Setting text colour
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
       
        //Nav-bar setup
    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //SETUP
        
        //Retrieves user's club data
        myClubs = clubController.getMyClubCollection()
        
        //Tableview background
        refreshTableView()
        
    }
    
    //UI setup when user taps into VC
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
        
        //Retrieve updated data
        let helper = ClubUpdateController()
        helper.getUpdates()
        do {
            myClubs = try persistenceManager.context.fetch(CoreClub.fetchRequest())
            
        } catch {
            print(error)
        }
        
        refreshTableView()
    }
    
    //Set background empty when there are no clubs and update tableview
    func refreshTableView() {
        
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

    
    // MARK: - Table view data source
    
    //Segue to the user's club info
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myClubInfoSegue" {
            
            //Setup for club information segue
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
    
    //Deletes the user's club on tap
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         let clubController = ClubModelController()
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            //Deleting Clubs
            let deletedClub = indexPath.row
            if let deletedEntity = myClubs?[deletedClub] {
            
                myClubs?.remove(at: deletedClub)
                clubController.removeClub(deleteClub: deletedEntity)
                
                //Tableview background
               refreshTableView()
            
            }
            
        }
    
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myClubs?.count ?? 0
    }
    
    //Shows user's club on the tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clubCell = tableView.dequeueReusableCell(withIdentifier: "myClubCell", for: indexPath)
        
        // Configure the cell...
        let index = indexPath.row
        if let name = myClubs?[index].name {
            clubCell.textLabel?.text = "\(String(describing: name))"
        }
        return clubCell
        
    }
 
    //Tap to check clubs to join
    @IBAction func joinClubsTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let clubsVC = storyboard.instantiateViewController(withIdentifier: "ClubTableViewController") as! ClubTableViewController
        navigationController?.pushViewController(clubsVC, animated: true)
    }
    
    
}
