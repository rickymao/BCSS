//
//  MyFeedViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-09.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class MyFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        navigationController?.navigationBar.barTintColor = UIColor.init(red:  0.612, green: 0.137, blue: 0.157, alpha: 100)
        
        
        navigationController?.navigationBar.tintColor = UIColor.init(red:  0.612, green: 0.137, blue: 0.157, alpha: 100)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red:  1, green: 1, blue: 1, alpha: 100)]
        
        
        //Back-Arrow
        let backImage = UIImage(named: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        // Do any additional setup after loading the view.
        
    }
  
  
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 90)
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red:   0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red:   0.612, green: 0.137, blue: 0.157, alpha: 100)
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red:   1, green: 1, blue: 1, alpha: 100)]
        
    }
    
    
    
  
    
  
    
    

}
