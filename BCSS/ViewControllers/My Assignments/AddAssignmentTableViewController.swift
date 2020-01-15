//
//  AddAssignmentTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-07.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import UserNotifications


protocol addAssignmentDelegate {
    
    func addAssignment(title: String, course: String, dueDate: String, notes: String?)
    
}

class AddAssignmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Done bar UI setup
        doneBarButtonSetUp()
        
        //Set nav-bar colours
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //End Edits
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEditing(tap:)))
        
        view.addGestureRecognizer(tap)
        
        //Input-View for Due Date
        let date = UIDatePicker()
        let current = NSDate()
        
        date.minimumDate = current as Date
        date.setDate(current as Date, animated: true)
        date.addTarget(self, action: #selector(dateChanged(date:)), for: .valueChanged)
        dateLabel.inputView = date
        
        //Tool bar UI setup
        let toolBarDone = UIToolbar()
        toolBarDone.sizeToFit()
        dateLabel.inputAccessoryView = toolBarDone
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
    }
    
    //OUTLETS
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var notesLabel: UITextView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var classLabel: UITextField!
    var addAssignmentDelegate: addAssignmentDelegate!
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Stops keyboard editing when tapping out of keyboard
    @objc func endEditing(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //Stops keyboard editing when tapping out of keyboard
    @objc func dateChanged(date: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: date.date)
        
        
    }
    
    //Sets view to current date
    @IBAction func setCurrentDate(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    //Set the done button to the right side of the bar
    func doneBarButtonSetUp() {
        
        let bar = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem = bar
        
    }
    
     //Checks if all important fields are filled out  saves the new assignment to coredata through the  delegate
    @objc func doneTapped() {
        
        if (titleLabel.text?.isEmpty)! {
            
            let alertMissing = UIAlertController(title: "Warning", message: "Please fill in the title!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            
            return
            
        }
        
        else if (classLabel.text?.isEmpty)! {
            
            let alertMissing = UIAlertController(title: "Warning", message: "Please fill in the class!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            
            return
            
            
        } else if (dateLabel.text?.isEmpty)! {
            
            let alertMissing = UIAlertController(title: "Warning", message: "Please fill in the due date!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            
            return
            
        }
        
            self.addAssignmentDelegate.addAssignment(title: titleLabel.text!, course: classLabel.text!, dueDate: dateLabel.text!, notes: notesLabel.text)
        
        }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    
    
}


   

