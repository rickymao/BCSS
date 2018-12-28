//
//  ScheduleViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-27.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit



class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 0.820, green: 0.114, blue: 0.165, alpha: 100)
        
        //Add-Button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "add"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addTapped))
        
        //setup schedule
        let schedule = try! persistenceManager.context.fetch(Schedule.fetchRequest()) as [Schedule]
        
        for classes in schedule {
            
            if classes.semester == 1 {
                classSemesterOne.append(classes)
                
            } else if classes.semester == 2 {
                classSemesterTwo.append(classes)
            }

        }
        
        classSemesterOne.sort { (Schedule, Schedule2) -> Bool in
            Schedule.block < Schedule2.block
        }
        
        classSemesterTwo.sort { (Schedule, Schedule2) -> Bool in
            Schedule.block < Schedule2.block
        }
        
        //Tableview background
        if classSemesterOne.count == 0 {
            self.tableView.backgroundView = background
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
        
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willMove(toParent parent: UIViewController?) {
        
        if let vcs = self.navigationController?.viewControllers {
            if vcs.contains(where: { return $0 is MyFeedViewController
            }) {
                
                navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 0.612, green: 0.137, blue: 0.157, alpha: 100)
                
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 100)]
                
            }
            
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var classSemesterOne: [Schedule] = []
    var classSemesterTwo: [Schedule] = []
    var semester = false
    let persistenceManager = PersistenceManager.shared
    @IBOutlet var background: UIView!
    
    @objc func addTapped() {
        
        performSegue(withIdentifier: "addSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            
            let addVC = segue.destination as! AddClassesTableViewController
            addVC.addDelegate = self
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ClassTableViewCell
        
        if semester {
        
        cell.blockLabel?.text = "Block: \(classSemesterTwo[indexPath.row].block)"
        cell.teacherLabel?.text = "Teacher: \(classSemesterTwo[indexPath.row].teacherName!)"
        cell.classLabel?.text = "Class: \(classSemesterTwo[indexPath.row].name!)"
        cell.roomLabel?.text = "Room: \(classSemesterTwo[indexPath.row].roomNumber!)"
        } else {
            cell.blockLabel?.text = "Block: \(classSemesterOne[indexPath.row].block)"
            cell.teacherLabel?.text = "Teacher: \(classSemesterOne[indexPath.row].teacherName!)"
            cell.classLabel?.text = "Class: \(classSemesterOne[indexPath.row].name!)"
            cell.roomLabel?.text = "Room: \(classSemesterOne[indexPath.row].roomNumber!)"
            
        }
        
        return cell
        }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            if semester {
                persistenceManager.context.delete(classSemesterTwo[indexPath.row])
                persistenceManager.save()
                classSemesterTwo.remove(at: indexPath.row)
            } else {
                persistenceManager.context.delete(classSemesterOne[indexPath.row])
                persistenceManager.save()
                classSemesterOne.remove(at: indexPath.row)
            }
        
                tableView.reloadData()
        
        }
    }
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if semester {
            return classSemesterTwo.count
        } else {
            return classSemesterOne.count
        }
    }

    @IBAction func segmentSemester(_ sender: UISegmentedControl) {
        
        semester = !semester
        
        if semester {
            //Tableview background
            if classSemesterOne.count == 0 {
                self.tableView.backgroundView = background
                self.tableView.separatorStyle = .none
            } else {
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = .singleLine
            }
            
            tableView.reloadData()
        } else {
            tableView.reloadData()
        }
        
    }


}

//MARK: Implementing CoreData
extension ScheduleViewController: addClassDelegate {

    func addClass(name: String, teacher: String, room: String, block: Int, semester: Int) {
            
        if let context = try! persistenceManager.context.fetch(Schedule.fetchRequest()) as? [Schedule] {

        checkClasses: for classes in context {
            
            if classes.block == Int16(block) && classes.semester == Int16(semester) {
                
                let deleteAlert = UIAlertController(title: "Warning", message: "There's a course in that block already", preferredStyle: .alert)
                let deleteAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
                deleteAlert.addAction(deleteAction)
                present(deleteAlert, animated: true, completion: nil)
                return
            }
    
        }
            
        
        let myClass = Schedule(context: persistenceManager.context)
        myClass.name = name
        myClass.teacherName = teacher
        myClass.roomNumber = room
        myClass.block = Int16(block)
        myClass.semester = Int16(semester)
        persistenceManager.save()
            
            let schedule = try! persistenceManager.context.fetch(Schedule.fetchRequest()) as [Schedule]
            
            if  schedule.last!.semester == 1 {
                classSemesterOne.append(schedule.last!)
                
            } else if schedule.last!.semester == 2 {
                classSemesterTwo.append(schedule.last!)
            }
            
            classSemesterOne.sort { (Schedule, Schedule2) -> Bool in
                Schedule.block < Schedule2.block
            }
            
            classSemesterTwo.sort { (Schedule, Schedule2) -> Bool in
                Schedule.block < Schedule2.block
            }
           
            
            tableView.reloadData()
            
            
            
        }
            

            
        
       
        }
    
    
    
    }


