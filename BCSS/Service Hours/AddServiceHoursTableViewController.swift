//
//  AddServiceHoursTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-17.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

protocol addHoursDelegate {
    func addHours(name: String, date: String, hours: Double, description: String)

}

class AddServiceHoursTableViewController: UITableViewController {
    
    var addDelegate: addHoursDelegate!
    var dateFormat = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //Bar Button setup
        doneBarButtonSetUp()
        
        //Input for hours
        hourField.keyboardType = UIKeyboardType.decimalPad
        
        //Input-View for Due Date
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.addTarget(self, action: #selector(dateChanged(date:)), for: .valueChanged)
        dateField.inputView = date
        
        //End Edits
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEditing(tap:)))
        
        view.addGestureRecognizer(tap)
        

    }
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var hourField: UITextField!
    @IBOutlet weak var descText: UITextView!
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func doneBarButtonSetUp() {
        
        let bar = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem = bar
        
        
    }
    
    @objc func endEditing(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(date: UIDatePicker) {
        
        dateFormat.dateFormat = "MM/dd/yyyy"
        dateFormat.dateStyle = .short
        dateField.text = dateFormat.string(from: date.date)
        
        
    }
    
    
    @IBAction func setCurrentDate(_ sender: Any) {
        dateFormat.dateFormat = "MM/dd/yyyy"
        dateField.text = dateFormat.string(from: Date())
    }
    
    
    
    @objc func doneTapped() {
        
        if (nameField.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Warning", message: "Please fill in the name!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            }
            
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            
        }
            
        else if (dateField.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Warning", message: "Please fill in the date!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            }
            
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            }
        
            else if (hourField.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Warning", message: "Please fill in the hours!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            }
            
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            
        } else {

        
        addDelegate.addHours(name: nameField.text!, date: dateField.text!, hours: Double(hourField.text!)!, description: descText.text)

        }
        
    }

   

}
