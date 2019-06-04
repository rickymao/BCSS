//
//  ProfileTableViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-26.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileTableViewController: UITableViewController {
    
    var name: String = String()
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()


        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        

        
    }
    
//    func getDatabase() {
//
//
//        let ref = Database.database().reference()
//
//        ref.child("clubKeyed").observe(.value) { (snapshot) in
//
//            for filteredSnapshot in snapshot.children {
//                if let snapshotJSON = filteredSnapshot as? DataSnapshot {
//
//
//                    //Extracting values
//                    let club = snapshotJSON.childSnapshot(forPath: "Club").value as! String
//                    let owner = snapshotJSON.childSnapshot(forPath: "Owner").value as! String
//                    let room = snapshotJSON.childSnapshot(forPath: "Room").value as! String
//                    let teacher = snapshotJSON.childSnapshot(forPath: "Teacher").value as! String
//                    let description = snapshotJSON.childSnapshot(forPath: "Description").value as! String
//                    let email = snapshotJSON.childSnapshot(forPath: "Email").value as! String
//                    let hours = snapshotJSON.childSnapshot(forPath: "Hours").value as! String
//                    let minutes = snapshotJSON.childSnapshot(forPath: "Minutes").value as! String
//                    let dayOfWeek = snapshotJSON.childSnapshot(forPath: "DayofWeek").value as! String
//
//
//                }
//
//
//            }
//
//
//                }
//
//
//            }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

}
