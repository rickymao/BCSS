//
//  AssignmentModuleTableViewCell.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-11.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

protocol assignmentModuleDelegate: class {
    
    func finishedAssignment(homeworkID: Homework, index: Int, button: UIButton)

}

class AssignmentModuleTableViewCell: UITableViewCell {

  
    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    var homeworkID: Homework?
    var index: Int?
    weak var delegate: assignmentModuleDelegate?
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        
        guard let hwID = self.homeworkID, let index = self.index else { return }
        
        self.delegate?.finishedAssignment(homeworkID: hwID, index: index, button: finishButton)
        
        
       
        

        
    }
}
