//
//  StudentHubTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-16.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class StudentHubTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellForRow(at: IndexPath(row: 1, section: 2))?.textLabel?.text = "Student Calendar"
        
            
        //Setup navigation bar
        navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 90)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
    
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
