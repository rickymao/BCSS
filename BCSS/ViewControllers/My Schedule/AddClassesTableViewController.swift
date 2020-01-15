//
//  AddClassesTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-29.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

protocol addClassDelegate {
    
    func addClass(name: String, teacher: String, room: String, block: Int, semester: Int)

}

class AddClassesTableViewController: UITableViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButtonSetUp()
        
        //End Edits
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEditing(tap:)))
        
        view.addGestureRecognizer(tap)
        
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var blocks = [1, 2, 3, 4]
    var semesters = [1, 2]
    var addDelegate: addClassDelegate!
    
    @IBOutlet weak var pickBlock: UIPickerView!
    @IBOutlet weak var classInput: UITextField!
    @IBOutlet weak var teacherInput: UITextField!
    @IBOutlet weak var roomInput: UITextField!
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    @objc func endEditing(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    func doneBarButtonSetUp() {
        
        let bar = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem = bar
        
    }
    
    @objc func doneTapped() {
        
        if let empty = classInput.text?.isEmpty {
        
        //Sends info back to menu
            if !empty {
            
                addDelegate?.addClass(name: classInput.text!, teacher: teacherInput.text!, room: roomInput.text!, block: blocks[pickBlock.selectedRow(inComponent: 1)], semester: semesters[pickBlock.selectedRow(inComponent: 0)])
        
        } else {
    
                //Sends a warning to fill in class name
            let alertMissing = UIAlertController(title: "Warning", message: "please fill in the class name", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertMissing.addAction(alertAction)
            present(alertMissing, animated: true, completion: nil)
            }
        }
        //returns back to menu
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
  
    
}

extension AddClassesTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return semesters.count
        } else if component == 1 {
            return blocks.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "Semester \(semesters[row])"
        } else if component == 1 {
            return "Block \(blocks[row])"
        }
        return nil
    }

    
}

