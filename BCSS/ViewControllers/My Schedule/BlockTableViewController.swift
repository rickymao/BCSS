//
//  BlockTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-12-08.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

class BlockTableViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Stop tableview scroll bouce
        tableView.bounces = false
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        
        //Sets default empty background
            tableView.tableFooterView = footerView
        self.navigationController?.navigationBar.backIndicatorImage = backImage
    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        //Sets back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //Sets nav-bar color
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.820, green: 0.114, blue: 0.165, alpha: 100)

        //SETUP
        
       setupBlocks()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {

        //SETUP
        
        setupBlocks()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //Limits user scrolling on schedule blocks
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    //Nav-bar color set on transition
    override func willMove(toParent parent: UIViewController?) {
        
        if let vcs = self.navigationController?.viewControllers {
            if vcs.contains(where: { return $0 is MyFeedViewController
            }) {
                
                navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 0.612, green: 0.137, blue: 0.157, alpha: 100)
                
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 100)]
                
            }
            
        }
        
    }
    
    //VARIABLES
    let persistenceManager = PersistenceManager.shared
    var blocks: [Blocks] = []
    let scheduleController = ScheduleModelController()
    
    
    //OUTLETS
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentSemester: UISegmentedControl!
    
    //Prepares information to be sent thru segue to block info VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scheduleSegue" {
            
            let vc = segue.destination as!
            BlockInfoTableViewController
            
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            
            vc.block = blocks[index]
            
            
            if blocks[index].blockX {
                vc.title = "Block X"
            } else {
                vc.title = "Block \(blocks[index].block)"
            }

            
        }
    }
    
    //Changes courses based on semester
    @IBAction func semesterTapped(_ sender: Any) {
        
        //SETUP
        setupBlocks()
        
    }
    

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return blocks.count
    }
    
    //Shows each block's information and sets the UI up for the cell
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blockCell", for: indexPath) as! BlockTableViewCell
        
        if (blocks[indexPath.row].blockX) {
            
            cell.blockLabel.text = "X"
        } else {
            cell.blockLabel.text = "\(blocks[indexPath.row].block)"
        }
        
        if let course =  blocks[indexPath.row].nameClass, let empty = blocks[indexPath.row].nameClass?.isEmpty {
            
            if empty {
                cell.oneCourseName.text = "No Class"
                cell.oneCourseName.textColor = UIColor.lightGray
                
            } else {
                cell.oneCourseName.text = course
                cell.oneCourseName.textColor = UIColor.black
            }
        } else {
             cell.oneCourseName.text = "No Class"
             cell.oneCourseName.textColor = UIColor.lightGray
        }
        
        if let course2 =  blocks[indexPath.row].nameClass2, let empty = blocks[indexPath.row].nameClass2?.isEmpty  {
            
            if empty {
                cell.twoCourseName.text = "No Class"
                cell.twoCourseName.textColor = UIColor.lightGray
            } else {
                cell.twoCourseName.text = course2
                cell.twoCourseName.textColor = UIColor.black
            }
       
        } else {
            cell.twoCourseName.text = "No Class"
            cell.twoCourseName.textColor = UIColor.lightGray
        }
        
        if let teacher = blocks[indexPath.row].nameTeacher {
            
            cell.oneTeacherName.text = teacher
            
        } else {
            cell.oneTeacherName.text = ""
        }
        
        if let teacher = blocks[indexPath.row].nameTeacher2 {
            
            cell.twoTeacherName.text = teacher
            
        } else {
            cell.twoTeacherName.text = ""
        }
        
      
        return cell
    }
    
    //Displays schedule and courses based on which semester the user taps on
    func setupBlocks() {
        
        switch segmentSemester.selectedSegmentIndex {
            
        case 0:
            
                blocks = scheduleController.getBlocks(semester: Int16(1))
                blocks.sort { (b1, b2) -> Bool in
                    b1.block < b2.block
                }
            
            tableView.reloadData()
            
        case 1:
            
               blocks = scheduleController.getBlocks(semester: Int16(2))
               blocks.sort { (b1, b2) -> Bool in
                    b1.block < b2.block
               }
               
            tableView.reloadData()
            
            
        default:
            print("Error")
        }
        
    }

   
}
