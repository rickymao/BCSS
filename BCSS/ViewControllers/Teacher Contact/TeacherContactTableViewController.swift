//
//  TeacherContactTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-22.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseDatabase

class TeacherContactTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Sets nav-bar's text color
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]

        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //Sets nav-bar's color
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.820, green: 0.114, blue: 0.165, alpha: 100)
        
        //SETUP
        setupTeacherList()


    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //VARIABLES
    var currentDepartment: Department!
    var teachers: [Teacher] = []
    var sortedTeachers: [Teacher] = []
    let teacherController = TeacherModelController()

    //filters and choose teachers depending on type and department
    func setupTeacherList() {
        
        if teacherController.getDepartment(department: currentDepartment) == "Applied Skills" {
            getTeacher(department: "Business Education")
            getTeacher(department: "Career Programs")
            getTeacher(department: "Home Economics")
            getTeacher(department: "Technology Education")
        }
        else if teacherController.getDepartment(department: currentDepartment) == "Student Services and Counsellors" {

            getTeacher(department: "Support Services")

        }
        else if teacherController.getDepartment(department: currentDepartment) == "Learning Support" {
            getTeacher(department: "LSS")
        }
        else if teacherController.getDepartment(department: currentDepartment) == "Arts" {
            getTeacher(department: "Fine Arts")
            getTeacher(department: "Performing Arts")
        }
        else if teacherController.getDepartment(department: currentDepartment) == "Administration" {

            getTeacher(type: "Administrator")
            getTeacher(type: "Secretary")
            getTeacher(type: "District")

        }

        else if teacherController.getDepartment(department: currentDepartment) == "Athletics" {
            getTeacher(department: "Physical Education")

        } else {

            //Retrieve data
            getTeacher(department: teacherController.getDepartment(department: currentDepartment))

        }
    }
    
    
    //Filters teachers based on type
    func getTeacher(type: String) {
        
        
        for teacher in teachers {
            
            if teacher.type == type {
                sortedTeachers.append(teacher)
                
            }
        
        }
      
        
    }
    
    //Filters teachers based on department
    func getTeacher(department: String) {
        
    
        for teacher in teachers {
            
            if teacher.department == department {
                sortedTeachers.append(teacher)
            }
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return sortedTeachers.count
    }

    //Shows a list of teachers according to department and type
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath)
        let index = indexPath.row
        cell.textLabel?.text = sortedTeachers[index].teacherName
        
        

        // Configure the cell...
        

        return cell
    }
    

    //Deselects row and starts Email App
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Email
        if !MFMailComposeViewController.canSendMail() {
            showError()
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
        
            let mail = configureMailController(email: sortedTeachers[indexPath.row].teacherEmail)
            self.present(mail, animated: true, completion: nil)
        }
        
    }
    
    //EMAIL SETUP
    
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
