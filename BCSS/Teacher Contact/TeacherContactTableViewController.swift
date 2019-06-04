//
//  TeacherContactTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-22.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDatabase

class TeacherContactTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.820, green: 0.114, blue: 0.165, alpha: 100)
        
        //Sort and choose data
        if getDepartment(department: currentDepartment) == "Applied Skills" {
            getDatabase(department: "Business Education")
            getDatabase(department: "Career Programs")
            getDatabase(department: "Home Economics")
            getDatabase(department: "Technology Education")
        }
        else if getDepartment(department: currentDepartment) == "Student Services and Counsellors" {
            
            getDatabase(department: "Support Services")
            
        }
        else if getDepartment(department: currentDepartment) == "Learning Support" {
            getDatabase(department: "LSS")
        }
        else if getDepartment(department: currentDepartment) == "Arts" {
            getDatabase(department: "Fine Arts")
            getDatabase(department: "Performing Arts")
        }
        else if getDepartment(department: currentDepartment) == "Administration and Secretaries" {
            
            getAdministrators(type: "Administrator")
            getAdministrators(type: "Secretary")
            getAdministrators(type: "District")
            
        }
       
        else if getDepartment(department: currentDepartment) == "Athletics" {
            getDatabase(department: "Physical Education")
        
        } else {
            
            //Retrieve data
            getDatabase(department: getDepartment(department: currentDepartment))
            
        }

        
        
        
        
        
        

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //chosen department
    var currentDepartment: Department!
    var currentTeachers: [Teacher] = []
    
    //Get teachers depending on department
    func getDepartment(department: Department) -> String {

        switch department {
            
        case .Mathematics: return "Mathematics"

        case .AppliedSkills: return "Applied Skills"
            
        case .Sciences: return "Sciences"

        case .StudentServices: return "Student Services and Counsellors"

        case .SocialStudies: return "Social Studies"

        case .Languages: return "Languages"

        case .English: return "English"
            
        case .ELL: return "ELL"

        case .LearningSupport: return "Learning Support"

        case .Arts: return "Arts"

        case .Athletics: return "Athletics"
            
        case .Administration: return "Administration"
    
            
        }
        
        
    }
    
    func getAdministrators(type: String) {
        
        let ref = Database.database().reference()
        
        
        ref.child("teacherKeyed").queryOrdered(byChild: "Type").queryEqual(toValue: type).observe(.value) { (snapshot) in
            
            //Collecting all filtered snapshots
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    //Extracting values
                    let lastName = snapshotJSON.childSnapshot(forPath: "LegalLast").value as! String
                    let firstName = snapshotJSON.childSnapshot(forPath: "LegalFirst").value as! String
                     let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
                    let fullName = firstName + lastName
                    //Add to array
                    
                    self.currentTeachers.append(Teacher(name: fullName, email: email))
                    
                }
                
                
            }
            
            self.tableView.reloadData()
        }
        
        
    }
    
    
    func getDatabase(department: String) {

        let ref = Database.database().reference()
        
        
        
        ref.child("teacherKeyed").queryOrdered(byChild: "Department").queryEqual(toValue: department).observe(.value) { (snapshot) in
        
            //Collecting all filtered snapshots
            for filteredSnapshot in snapshot.children {
                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
                    
                    print(snapshotJSON)
                    //Extracting values
                    let lastName = snapshotJSON.childSnapshot(forPath: "LegalLast").value as! String
                    let firstName = snapshotJSON.childSnapshot(forPath: "LegalFirst").value as! String
                    let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
                    let fullName = firstName + " " + lastName
                    //Add to array
                 
                    self.currentTeachers.append(Teacher(name: fullName, email: email))
                    
                }
           
                
            }
        
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return currentTeachers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath)
        let index = indexPath.row
        cell.textLabel?.text = currentTeachers[index].teacherName
        
        

        // Configure the cell...
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Email
        if !MFMailComposeViewController.canSendMail() {
            showError()
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
        
            let mail = configureMailController(email: currentTeachers[indexPath.row].teacherEmail)
            self.present(mail, animated: true, completion: nil)
        }
        
    }
    
    //Setting up Email
    func configureMailController(email: String) -> MFMailComposeViewController {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([email])
        
        return composeVC
        
    }
    
    //Handles Email send/cancel
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //error when Mail app isn't configured
    func showError() {
        
        let alert = UIAlertController(title: "Email Error", message: "Check your Mail app", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        
        
    }


}
