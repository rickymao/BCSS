//
//  InfoAssignmentTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-09.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class InfoAssignmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Save button setup
        saveBarButtonSetUp()
        
        //Input-View for Due Date
        let date = UIDatePicker()
        let current = NSDate()
        
        date.minimumDate = current as Date
        date.setDate(current as Date, animated: true)
        date.addTarget(self, action: #selector(dateChanged(date:)), for: .valueChanged)
        dueDateAssignment.inputView = date
        
        //Toolbar setup
        let toolBarDone = UIToolbar()
        toolBarDone.sizeToFit()
        dueDateAssignment.inputAccessoryView = toolBarDone
        
        //Set nav-bar colours
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //End Edits
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEditing(tap:)))
        
        view.addGestureRecognizer(tap)
        
        //SETUP
        
        //Setup Information for assignment
        titleAssignment.text = name
        classAssignment.text = course
        dueDateAssignment.text = dueDate
        notesAssignment.text = notes
        
    }
    
    //VARIABLES
    var name: String!
    var course: String!
    var dueDate: String!
    var notes: String!
    var uuid: UUID!
    let assignmentController = AssignmentModelController()
    let persistenceManager = PersistenceManager.shared
    let dateFormatter = DateFormatter()
    
    //OUTLETS
    @IBOutlet weak var titleAssignment: UITextField!
    @IBOutlet weak var classAssignment: UITextField!
    @IBOutlet weak var dueDateAssignment: UITextField!
    @IBOutlet weak var notesAssignment: UITextView!
    
    //tracks when date picker scrolls and changes date to match
    @objc func dateChanged(date: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dueDateAssignment.text = dateFormatter.string(from: date.date)
        
        
    }
    
    //Sets up the UI for the save button
    func saveBarButtonSetUp() {
        
        let bar = UIBarButtonItem(barButtonSystemItem: .save
            , target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = bar
        
        
    }
    
    //Stops keyboard editing when tapping out of keyboard
    @objc func endEditing(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //Sets view to current date
    @IBAction func setCurrentDate(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dueDateAssignment.text = dateFormatter.string(from: Date())
    }
    
    
    //Checks if all important fields are filled out and if so saves the edited or new assignment to coredata
    @objc func saveTapped() {
        
        if (titleAssignment.text?.isEmpty)! {
            
            let alertMissing = UIAlertController(title: "Warning", message: "Please fill in the title!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            
            return
            
        }
            
        else if (classAssignment.text?.isEmpty)! {
            
            let alertMissing = UIAlertController(title: "Warning", message: "Please fill in the class!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            
            return
            
            
        } else if (dueDateAssignment.text?.isEmpty)! {
            
            let alertMissing = UIAlertController(title: "Warning", message: "Please fill in the due date!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            
            return
            
        }
        
        assignmentController.editAssignment(title: titleAssignment.text!, course: classAssignment.text!, dueDate: dueDateAssignment.text!, note: notesAssignment.text, uuid: uuid)
        

      
        //returns back to menu
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }



}
