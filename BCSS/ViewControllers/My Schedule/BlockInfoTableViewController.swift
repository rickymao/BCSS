//
//  BlockInfoTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-12-08.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import CoreData

class BlockInfoTableViewController: UITableViewController {
    
    //VARIABLES
    let persistenceManager = PersistenceManager.shared
    var block: Blocks? = nil
    let scheduleController = ScheduleModelController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        saveBarButtonSetUp()
        
        //Setup textfields
        className?.text = block?.nameClass ?? ""

        className2?.text = block?.nameClass2 ?? ""
        roomNumber?.text = block?.roomNumber ?? ""
        roomNumber2?.text = block?.roomNumber2 ?? ""
        teacherName?.text = block?.nameTeacher ?? ""
        teacherName2?.text = block?.nameTeacher2 ?? ""
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //End Edits
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEditing(tap:)))
        
        view.addGestureRecognizer(tap)

       
    }

    //OUTLETS
    @IBOutlet weak var className: UITextField!
    @IBOutlet weak var roomNumber: UITextField!
    @IBOutlet weak var teacherName: UITextField!
    
    @IBOutlet weak var className2: UITextField!
    @IBOutlet weak var roomNumber2: UITextField!
    @IBOutlet weak var teacherName2: UITextField!

    @IBOutlet weak var sameAsDay1Button: UISwitch!
    
    // MARK: - Table view data source

    //Sets the right side of bar as save button to save course changes
    func saveBarButtonSetUp() {
        let bar = UIBarButtonItem(barButtonSystemItem: .save
            , target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = bar
        
    }
    
    @objc func saveTapped() {
        
            let schedule = scheduleController.getBlocks(semester: block?.semester, block: block?.block)
            
            //Saves new values to coredata
            schedule[0].setValue(className.text, forKey: "nameClass")
            schedule[0].setValue(className2.text, forKey: "nameClass2")
            
            schedule[0].setValue(teacherName.text, forKey: "nameTeacher")
            schedule[0].setValue(teacherName2.text, forKey: "nameTeacher2")
            
            schedule[0].setValue(roomNumber.text, forKey: "roomNumber")
            schedule[0].setValue(roomNumber2.text, forKey: "roomNumber2")
    
            
            persistenceManager.save()
            

        //returns back to menu
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //End keyboard editing
    @objc func endEditing(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    //Copies Day 1 courses to Day 2
    @IBAction func sameAsDay1Tapped(_ sender: Any) {
        
        if sameAsDay1Button.isOn {
            
            className2.text = className.text
            teacherName2.text = teacherName.text
            roomNumber2.text = roomNumber.text
            
        } else {
            
            className2.text = ""
            teacherName2.text = ""
            roomNumber2.text = ""
            
        }
        
        
        
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }




}
