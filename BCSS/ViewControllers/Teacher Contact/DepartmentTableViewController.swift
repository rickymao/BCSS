//
//  DepartmentTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-22.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DepartmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Set nav-bar text color
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]

        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //Set nav-bar color
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.820, green: 0.114, blue: 0.165, alpha: 100)
        
        refTeacher.keepSynced(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        //SETUP
        
       //Refresh data
       teacherLoaded = []
       getDatabase()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //VARIABLES
    var teacherLoaded: [Teacher] = []
    let refTeacher = Database.database().reference().child("teacherKeyed")
    let teacherController = TeacherModelController()
    
    //departments listing
    var departments: [Department] = [.Mathematics, .Sciences, .AppliedSkills, .Athletics, .ELL, .English, .LearningSupport, .Languages, .SocialStudies, .StudentServices, .Arts, .Administration]
    


    //#Change
    func getDatabase() {
        
        teacherController.getTeacherCollection { (teachersDB) in
            if let newTeachers = teachersDB {
                self.teacherLoaded = newTeachers
            } else {
                self.teacherLoaded = []
            }
        }
   }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return departments.count
    }
    
    //Show departments at school
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCells", for: indexPath)
        
        let indexPath = indexPath.row
        
        //Setting each department text
        switch departments[indexPath] {
            
        case .Mathematics: cell.textLabel?.text = "Mathematics"
        case .Sciences: cell.textLabel?.text = "Sciences"
        case .AppliedSkills: cell.textLabel?.text = "Applied Skills"
        case .Athletics: cell.textLabel?.text = "Athletics"
        case .ELL: cell.textLabel?.text = "ELL"
        case .English: cell.textLabel?.text = "English"
        case .LearningSupport: cell.textLabel?.text = "Learning Support"
        case .Languages: cell.textLabel?.text = "Languages"
        case .SocialStudies: cell.textLabel?.text = "Social Studies"
        case .StudentServices: cell.textLabel?.text = "Student Services and Counsellors"
        case .Arts: cell.textLabel?.text = "Visual and Performing Arts"
        case .Administration: cell.textLabel?.text = "Administration"
            
        }
        
        return cell
    }

    
    //Passing chosen department data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let contactController = segue.destination as! TeacherContactTableViewController
        if let index = tableView.indexPathForSelectedRow?.row {
            contactController.currentDepartment = departments[index]
        }
        contactController.teachers = teacherLoaded
        
    }
    
}
