//
//  AssignmentTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-04.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import UserNotifications

class AssignmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP

        //Setting up Nav-bar
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //Add-Button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "add"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addTapped))
        
        
        //Notifications
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
        }
        
        //SETUP
        setupAssignments()
        
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //SETUP
        setupAssignments()
        
    }
    
    
    //VARIABLES
    var assignments: [Assignment] = []
    let persistenceManager = PersistenceManager.shared
    @IBOutlet var background: UIView!
    let assignmentController = AssignmentModelController()
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Segues to the add assignment screen
    @objc func addTapped() {
        
        performSegue(withIdentifier: "addAssignmentSegue", sender: nil)
    
    }
    
    //Sets nav-bar colour when users move to this screen
    override func willMove(toParent parent: UIViewController?) {
        
        if let vcs = self.navigationController?.viewControllers {
            if vcs.contains(where: { return $0 is MyFeedViewController
            }) {
                
                navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 0.612, green: 0.137, blue: 0.157, alpha: 100)
                
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 100)]
                
            }
            
        }
        
    }
    
    //Segue to AddAssignments and InfoAssignment while sending info to info screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addAssignmentSegue" {
            
            let addVC = segue.destination as! AddAssignmentTableViewController
            addVC.addAssignmentDelegate = self
        
        }
        if segue.identifier == "infoAssignmentSegue" {
            

            let infoVC = segue.destination as! InfoAssignmentTableViewController
            if let selected = tableView.indexPathForSelectedRow?.row {
                infoVC.name =  "\(assignments[selected].title!)"
                infoVC.course = "\(assignments[selected].course!)"
                infoVC.dueDate =  "\(assignments[selected].dueDate!)"
                infoVC.notes = assignments[selected].notes
                infoVC.uuid = assignments[selected].uuid
            
            
            }
        }
    }
    
    //Setup
    func setupAssignments() {
        
        //Setting assignments
        assignments = assignmentController.getMyAssignments()
           
               
               //Setting tableview background
               if assignments.count == 0 {
                   self.tableView.backgroundView = background
                   self.tableView.separatorStyle = .none
               } else {
                   self.tableView.backgroundView = nil
                   self.tableView.separatorStyle = .singleLine
               }
               
               tableView.reloadData()
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Finished assignment action
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let doneButton = UITableViewRowAction.init(style: .normal, title: "Done") { (doneButton, IndexPath) in
            
            self.assignmentController.deleteAssignment(assignment: self.assignments[indexPath.row])

            self.assignments.remove(at: indexPath.row)
            
           
                //Tableview background
                if self.assignments.count == 0 {
                    self.tableView.backgroundView = self.background
                    self.tableView.separatorStyle = .none
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .singleLine
                }
        
            
            tableView.reloadData()
        }
        
        doneButton.backgroundColor = UIColor.green
        return [doneButton]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return assignments.count
    }
    
    //Shows assignments on tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! AssignmentTableViewCell
        
        cell.titleLabel.text = assignments[indexPath.row].title
        cell.dueDateLabel.text = "Due on \(assignments[indexPath.row].dueDate!)"
        
        
        return cell
    }
    
 
}

//Adds new assignments to coredata
extension AssignmentTableViewController: addAssignmentDelegate {
    
    func addAssignment(title: String, course: String, dueDate: String, notes: String?) {
        
        let assignment = assignmentController.addAssignment(title: title, course: course, dueDate: dueDate, notes: notes)

        assignments.append(assignment)
        self.navigationController?.popViewController(animated: true)
        
        tableView.reloadData()
    }
    

    
    
}
