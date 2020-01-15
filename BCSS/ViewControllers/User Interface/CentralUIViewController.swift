//
//  CentralUIViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-12.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import UIKit

class CentralUIViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

//Sets all back button to no-text

extension UIViewController {
    
    open override func awakeFromNib() {
           navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       }
}

