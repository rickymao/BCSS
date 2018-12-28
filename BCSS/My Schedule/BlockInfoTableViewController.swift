//
//  BlockInfoTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-12-08.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import CoreData

class BlockInfoTableViewController: UITableViewController {
    
    let persistenceManager = PersistenceManager.shared
    var block: Blocks? = nil

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

    @IBOutlet weak var className: UITextField!
    @IBOutlet weak var roomNumber: UITextField!
    @IBOutlet weak var teacherName: UITextField!
    
    @IBOutlet weak var className2: UITextField!
    @IBOutlet weak var roomNumber2: UITextField!
    @IBOutlet weak var teacherName2: UITextField!
    
    
    // MARK: - Table view data source

    func saveBarButtonSetUp() {
        
        let bar = UIBarButtonItem(barButtonSystemItem: .save
            , target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = bar
        
        
    }
    
    @objc func saveTapped() {
        do {
        
            let fetch: NSFetchRequest<Blocks>  = Blocks.fetchRequest()
            
            guard let blockNum = block?.block else {return}
            guard let blockSem = block?.semester else {return}
            print(blockNum)
            
            let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "block == %@" , blockNum as NSNumber), NSPredicate(format: "semester == %@" , blockSem as NSNumber)])
            
                 fetch.predicate = andPredicate
           
        
        let context = try persistenceManager.context.fetch(fetch)
        as [NSManagedObject]
            
            print(context)
            
           var schedule = context
            
            schedule[0].setValue(className.text, forKey: "nameClass")
            if let empty = className2.text?.isEmpty {
                if empty {
                    schedule[0].setValue(className.text, forKey: "nameClass2")
                } else {
                    schedule[0].setValue(className2.text, forKey: "nameClass2")
                }
                
            } else {
                schedule[0].setValue(className.text, forKey: "nameClass2")
            }
            schedule[0].setValue(teacherName.text, forKey: "nameTeacher")
            if let empty = teacherName2.text?.isEmpty {
                if empty {
                    schedule[0].setValue(teacherName.text, forKey: "nameTeacher2")
                } else {
                     schedule[0].setValue(teacherName2.text, forKey: "nameTeacher2")
                }
                
            } else {
               schedule[0].setValue(teacherName2.text, forKey: "nameTeacher2")
            }
           
            schedule[0].setValue(roomNumber.text, forKey: "roomNumber")
            
            if let empty = roomNumber2.text?.isEmpty {
                if empty {
                    schedule[0].setValue(roomNumber.text, forKey: "roomNumber2")
                } else {
                    schedule[0].setValue(roomNumber2.text, forKey: "roomNumber2")
                }
                
            } else {
                schedule[0].setValue(roomNumber2.text, forKey: "roomNumber2")
            }
            
            
            persistenceManager.save()
            
            
            
        } catch {
            print(error)
        }
        
        //returns back to menu
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func endEditing(tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }




}
