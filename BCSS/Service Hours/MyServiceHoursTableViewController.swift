//
//  MyServiceHoursTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-16.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class MyServiceHoursTableViewController: UITableViewController {
    
    var jobs: [Work] = []
    let dateFormat = DateFormatter()
    let persistenceManager = PersistenceManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
     
        
        //setting jobs
        do {
            let context = try persistenceManager.context.fetch(Work.fetchRequest()) as [Work]
            jobs = context
            print(context)
            print(jobs)
    
        } catch {
            print(error)
        }
        
        //Tableview background
        if jobs.count == 0 {
            self.tableView.backgroundView = background
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //setting jobs
        do {
            let context = try persistenceManager.context.fetch(Work.fetchRequest()) as [Work]
            jobs = context
            print(context)
            print(jobs)
            
        } catch {
            print(error)
        }
        
        //Tableview background
        if jobs.count == 0 {
            self.tableView.backgroundView = background
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        
    }
    
    @IBOutlet var background: UIView!

    @objc func addTapped() {
        
        performSegue(withIdentifier: "addHoursSegue", sender: nil)
        
    }
    
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let serviceHour = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath)
        
             serviceHour.textLabel?.text = jobs[indexPath.row].name
            serviceHour.detailTextLabel?.text = "Date: \(jobs[indexPath.row].date!) Hours: \(jobs[indexPath.row].hours)"
    
        return serviceHour
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            persistenceManager.context.delete(jobs[indexPath.row])
            persistenceManager.save()
            jobs.remove(at: indexPath.row)
            
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
    }

}

extension MyServiceHoursTableViewController: addHoursDelegate {
    
    func addHours(name: String, date: String, hours: Double, description: String) {
        
        let work = Work(context: persistenceManager.context)
        work.date = date
        work.name = name
        work.hours = hours
        work.extra = description
        persistenceManager.save()
        
        jobs.append(work)
        tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
            
        }
        
    }

