//
//  StudentHubNavigationViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-12.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import UIKit

class StudentHubNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //UI SETUP
                self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
