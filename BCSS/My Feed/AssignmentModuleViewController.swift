//
//  AssignmentModuleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-10.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import UserNotifications

class AssignmentModuleViewController: UIViewController {
    
    var assignmentFiltered: [Homework] = []
    var assignments: [Homework] = []
    let persistenceManager = PersistenceManager.shared
    let dateFormat = DateFormatter()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormat.dateFormat = "MM/dd/yyyy"
        
        //Observer
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //round corners
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true

        // Do any additional setup after loading the view.
        
        //setting assignments
        do {
            let context = try persistenceManager.context.fetch(Homework.fetchRequest()) as [Homework]

           assignmentFiltered = context
        } catch {
            print(error)
        }
        
        if assignmentFiltered.count == 0 {
        assignmentTable.backgroundView = background
        } else {
            assignmentTable.backgroundView = nil
        }
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        dateFormat.dateFormat = "MM/dd/yyyy"
        do {
            let context = try persistenceManager.context.fetch(Homework.fetchRequest()) as [Homework]
          assignmentFiltered = context
        } catch {
            print(error)
        }
        
        //Sets empty background
        if assignmentFiltered.count == 0 {
            assignmentTable.backgroundView = background
            assignmentTable.separatorStyle = .none
        } else {
            assignmentTable.backgroundView = nil
            assignmentTable.separatorStyle = .singleLine
        }
        
        assignmentTable.reloadData()
        
    }
    
 
    @IBOutlet weak var assignmentTable: UITableView!
    @IBOutlet var background: UIView!
    
    
    @objc func willEnterForeground() {
        
        
        dateFormat.dateFormat = "MM/dd/yyyy"
        do {
            let context = try persistenceManager.context.fetch(Homework.fetchRequest()) as [Homework]
            assignmentFiltered = context
        } catch {
            print(error)
        }
        
        if assignmentFiltered.count == 0 {
            assignmentTable.backgroundView = background
        } else {
            assignmentTable.backgroundView = nil
        }
        
        assignmentTable.reloadData()
        
        
        
    }
    
    
    func disableOtherCells() {
        
        var count = assignmentFiltered.count - 1
        while (count >= 0) {
            
           let cell = assignmentTable.cellForRow(at: IndexPath.init(row: count, section: 0)) as! AssignmentModuleTableViewCell
            
                cell.finishButton.isEnabled = false
            count = count - 1
        }
            
        
            
            
        }
    
    @objc func enableOtherCells() {
        
        var count = assignmentFiltered.count - 1
        while (count >= 0) {
            
            let cell = assignmentTable.cellForRow(at: IndexPath.init(row: count, section: 0)) as! AssignmentModuleTableViewCell
            
            cell.finishButton.isEnabled = true
            count = count - 1
        }
        
        
        
        
    }
        
        
        
    
  
    


}

extension AssignmentModuleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentFiltered.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let assignment = tableView.dequeueReusableCell(withIdentifier: "assignmentModuleCell", for: indexPath) as! AssignmentModuleTableViewCell
        
    
        
        
        assignment.assignmentLabel.text = assignmentFiltered[indexPath.row].title
    
        assignment.dueDateLabel.text = assignmentFiltered[indexPath.row].dueDate!
        
        assignment.homeworkID = assignmentFiltered[indexPath.row]
        
        assignment.index = indexPath.row
        
        assignment.delegate = self

         return assignment
            
        }
        
        
        
    
        
    }

extension AssignmentModuleViewController: assignmentModuleDelegate {
    func finishedAssignment(homeworkID: Homework, index: Int, button: UIButton) {
        
        button.isEnabled = false
        
        button.setImage(UIImage.init(named: "check"), for: .normal)
        let indexPath = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
           
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(self.assignmentFiltered[indexPath.row].uuid.uuidString)tomorrow", "\(self.assignmentFiltered[indexPath.row].uuid.uuidString)hour"])
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(self.assignmentFiltered[indexPath.row].uuid.uuidString)tomorrow", "\(self.assignmentFiltered[indexPath.row].uuid.uuidString)hour"])

            self.assignmentFiltered.remove(at: index)
            self.persistenceManager.context.delete(homeworkID)
            self.persistenceManager.save()
            

            self.assignmentTable.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
            button.setImage(UIImage.init(named: "selectCircle"), for: .normal)
        }
        
      
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(325)) {
            button.isEnabled = true
            if self.assignmentFiltered.count == 0 {
                self.assignmentTable.backgroundView = self.background
            } else {
                self.assignmentTable.backgroundView = nil
            }
            
            self.assignmentTable.reloadData()
        }
     
    
    
    
}

    
    
    
    
    



    
    
    
    
    

}
