//
//  MyServiceHoursTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-16.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

class MyServiceHoursTableViewController: UITableViewController {
    
    //VARIABLES
    var jobs: [Work] = []
    let dateFormat = DateFormatter()
    let persistenceManager = PersistenceManager.shared
    let workController = WorkModelController()
    
    //OUTLETS
    @IBOutlet var background: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Setting text colour for nav-bar
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //Add-Button
        let addButton = UIBarButtonItem.init(image: UIImage.init(named: "add"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addTapped))
        let infoButton = UIBarButtonItem.init(image: UIImage.init(named: "info"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(infoTapped))
        self.navigationItem.rightBarButtonItems = [addButton, infoButton]
        
     
        refreshTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    

    //Segue to the add work exp. VC
    @objc func addTapped() {
        
        performSegue(withIdentifier: "addHoursSegue", sender: nil)
        
    }
    
    //Adds up hours and showcase it to an user
    @objc func infoTapped() {
        
        var stat: Double = 0
        
        for job in jobs {
            
           stat += job.hours
            
        }
        
        let alert = UIAlertController.init(title: "Hours", message: "Total Hours: \(stat)", preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction.init(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    //Segue to work exp. info
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addHoursSegue" {
            
            let AddVC = segue.destination as! AddServiceHoursTableViewController
            AddVC.addDelegate = self
            
            
        }
        else if segue.identifier == "hoursInfoSegue" {
            
            let infoVC = segue.destination as! ServiceHoursInfoTableViewController
            
            guard let index = tableView.indexPathForSelectedRow?.row else
            {return}
            
            infoVC.name = jobs[index].name
            infoVC.date = jobs[index].date
            infoVC.hours = jobs[index].hours
            infoVC.desc = jobs[index].extra
            
        }
    }
    
    //Set background empty if there are no work exp. hours
    func refreshTableView() {
        
        //Tableview background
        if jobs.count == 0 {
            self.tableView.backgroundView = background
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobs.count
    }

    //Shows work exp. hours on tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let serviceHour = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath)
        
             serviceHour.textLabel?.text = jobs[indexPath.row].name
            serviceHour.detailTextLabel?.text = "Date: \(jobs[indexPath.row].date!) Hours: \(jobs[indexPath.row].hours)"
    
        return serviceHour
        
    }
    
    //Deletes volunteer/job hours
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let deletedJob = jobs[indexPath.row]
            workController.deleteWorkHours(works: deletedJob)
            jobs.remove(at: indexPath.row)

            refreshTableView()
            
        }
    }

}

//Delegate implementation
extension MyServiceHoursTableViewController: addHoursDelegate {
    
    //Adds new work exp. to core data
    func addHours(name: String, date: String, hours: Double, description: String) {
        
        let workController = WorkModelController()
        let work = workController.addWork(name: name, date: date, hours: hours, description: description)
        
        jobs.append(work)
        tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
            
        }
        
    }

