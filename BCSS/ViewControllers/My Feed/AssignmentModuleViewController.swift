//
//  AssignmentModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import UserNotifications

class AssignmentModuleViewController: UIViewController {
    
    //VARIABLES
    var assignmentFiltered: [Assignment] = []
    var assignment: [Assignment] = []
    let persistenceManager = PersistenceManager.shared
    let assignmentController = AssignmentModelController()
    let dateFormatter = DateFormatter()
    
    

    //OUTLETS
    @IBOutlet weak var assignmentTable: UITableView!
    @IBOutlet var background: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Rounding corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
        
        //Formatting date
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        //Observer
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //SETUP
        
        //Setup the tableview and it's content
        setupAssignment()
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Setup the tableview and it's content
        setupAssignment()

    }
    
    
    @objc func willEnterForeground() {
        //Setup the tableview and it's content
        setupAssignment()
        
    }
    
    
    //Delay tap and allows delegation of finishedAssignment() to complete
    func disableOtherCells() {
        
        var count = assignmentFiltered.count - 1
        while (count >= 0) {
            
           let cell = assignmentTable.cellForRow(at: IndexPath.init(row: count, section: 0)) as! AssignmentModuleTableViewCell
            
                cell.finishButton.isEnabled = false
            count = count - 1
        }
            
        }
    @objc func enableOtherCells() {
        
        var count = assignmentFiltered.count - 1
        while (count >= 0) {
            
            let cell = assignmentTable.cellForRow(at: IndexPath.init(row: count, section: 0)) as! AssignmentModuleTableViewCell
            
            cell.finishButton.isEnabled = true
            count = count - 1
        }
        
        
        
        
    }
    
    /* Sets up the tableview's background while also fetching assignment from CoreData */
    func setupAssignment() {
        
        //Fetching user's assignment from Core Data and setting it to assignmentFiltered
        assignmentFiltered = assignmentController.getMyAssignments()
        //Setting tableviews background based on if it is empty or not
        if assignmentFiltered.count == 0 {
        assignmentTable.backgroundView = background
        } else {
            assignmentTable.backgroundView = nil
        }
        
        assignmentTable.reloadData()

        
    }
        
        

}

extension AssignmentModuleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentFiltered.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let assignment = tableView.dequeueReusableCell(withIdentifier: "AssignmentModuleTableViewCell", for: indexPath) as! AssignmentModuleTableViewCell
        
    
        
        //Initializes the cell of each row with the assignment's information
        assignment.assignmentLabel.text = assignmentFiltered[indexPath.row].title
    
        assignment.dueDateLabel.text = assignmentFiltered[indexPath.row].dueDate!
        
        assignment.assignmentID = assignmentFiltered[indexPath.row]
        
        assignment.index = indexPath.row
        
        assignment.delegate = self

         return assignment
            
        }
        
        
        
    
        
    }

//Delegate protocol
extension AssignmentModuleViewController: AssignmentModuleDelegate {
    
    //Deletes the assignment asynchronously
    func finishedAssignment(assignmentID: Assignment, index: Int, button: UIButton) {
        
        //Disables clear button and notify the user that the assignment has been removed with a check
        button.isEnabled = false
        
        button.setImage(UIImage.init(named: "check"), for: .normal)
        let indexPath = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {

            //Removes the assignment from the application
            let assignmentController = AssignmentModelController()
            assignmentController.deleteAssignment(assignment: assignmentID)
                
            //Deletes it from the row
            self.assignmentFiltered.remove(at: index)
            self.assignmentTable.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        
        //Updates the tableview UI by checking the background and changing the assignment clear symbol
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
            button.setImage(UIImage.init(named: "selectCircle"), for: .normal)
        }
        
      
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(325)) {
            button.isEnabled = true
            if self.assignmentFiltered.count == 0 {
                self.assignmentTable.backgroundView = self.background
            } else {
                self.assignmentTable.backgroundView = nil
            }
            
            self.assignmentTable.reloadData()
        }
     
    
    
    
}

}
