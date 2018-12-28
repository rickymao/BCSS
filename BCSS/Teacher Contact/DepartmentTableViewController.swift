//
//  DepartmentTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-22.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class DepartmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.820, green: 0.114, blue: 0.165, alpha: 100)


        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //departments listing
    var departments: [Department] = [.Mathematics, .Sciences, .AppliedSkills, .Athletics, .ELL, .English, .LearningSupport, .Languages, .Socials, .Services, .Arts]
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return departments.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCells", for: indexPath)
        
        let indexPath = indexPath.row
        
        //Setting each department
        switch departments[indexPath] {
            
        case .Mathematics: cell.textLabel?.text = "Mathematics"
        case .Sciences: cell.textLabel?.text = "Sciences"
        case .AppliedSkills: cell.textLabel?.text = "Applied Skills"
        case .Athletics: cell.textLabel?.text = "Athletics"
        case .ELL: cell.textLabel?.text = "ELL"
        case .English: cell.textLabel?.text = "English"
        case .LearningSupport: cell.textLabel?.text = "Learning Support"
        case .Languages: cell.textLabel?.text = "Languages"
        case .Socials: cell.textLabel?.text = "Social Studies"
        case .Services: cell.textLabel?.text = "Student Services"
        case .Arts: cell.textLabel?.text = "Visual and Performing Arts"
            
        }
        
        return cell
    }

    
    //Passing chosen department data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let contactController = segue.destination as! TeacherContactTableViewController
        if let index = tableView.indexPathForSelectedRow?.row {
            contactController.currentDepartment = departments[index]
        }
        
    }
    
}
