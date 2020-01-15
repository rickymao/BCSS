//
//  MyFeedViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-09.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

class MyFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       //UI SETUP
        
       //Setup the color, text color, and tint of the nav-bar
        navigationController?.navigationBar.barTintColor = UIColor.init(red:  0.612, green: 0.137, blue: 0.157, alpha: 100)
        navigationController?.navigationBar.tintColor = UIColor.init(red:  0.612, green: 0.137, blue: 0.157, alpha: 100)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red:  1, green: 1, blue: 1, alpha: 100)]
        
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        //SETUP
        
        //Updates club information
        let updateHelper = ClubUpdateController()
        updateHelper.getUpdates()
    }
  
  
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //Setup the text color and tint of the nav-bar
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 90)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red:   0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         //Setup the text color and tint of the nav-bar
        navigationController?.navigationBar.barTintColor = UIColor.init(red:   0.612, green: 0.137, blue: 0.157, alpha: 100)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red:   1, green: 1, blue: 1, alpha: 100)]
        
        //Club updates
        let updateHelper = ClubUpdateController()
        updateHelper.getUpdates()

        
        
    }
    
    
    
    
  
    
  
    
    

}
