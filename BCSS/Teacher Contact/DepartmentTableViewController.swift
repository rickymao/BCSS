//
//  DepartmentTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-22.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DepartmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refTeacher.keepSynced(true)
        
        
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]

        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.820, green: 0.114, blue: 0.165, alpha: 100)
        
    }
    var teacherLoaded: [Teacher] = []
    let refTeacher = Database.database().reference(withPath: "teacherKeyed")
    
    override func viewDidAppear(_ animated: Bool) {
       
       //Refresh data
       teacherLoaded = []
       getDatabase()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //departments listing
    var departments: [Department] = [.Mathematics, .Sciences, .AppliedSkills, .Athletics, .ELL, .English, .LearningSupport, .Languages, .SocialStudies, .StudentServices, .Arts, .Administration]
    
    func getDatabase() {
        
        let ref = Database.database().reference()
        
        ref.child("teacherKeyed").observeSingleEvent(of: .value) { (snapshot) in
            
            //Collecting all filtered snapshots
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    let lastName = snapshotJSON.childSnapshot(forPath: "LegalLast").value as! String
                    let firstName = snapshotJSON.childSnapshot(forPath: "LegalFirst").value as! String
                    let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
                    let department = snapshotJSON.childSnapshot(forPath: "Department").value as? String
                    let type = snapshotJSON.childSnapshot(forPath: "Type").value as! String
                    let homeroom = snapshotJSON.childSnapshot(forPath: "homeroom").value as? String
                    let fullName = firstName + " " + lastName
                    
                    
            self.teacherLoaded.append(Teacher(name: fullName, email: email, department: department, type: type, homeroom: homeroom))
                    
            
            
        }
        
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
