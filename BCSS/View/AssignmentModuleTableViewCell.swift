//
//  AssignmentModuleTableViewCell.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-11-11.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

//Delegate protocol
protocol AssignmentModuleDelegate: class {
    
    func finishedAssignment(assignmentID: Assignment, index: Int, button: UIButton)

}
class AssignmentModuleTableViewCell: UITableViewCell {


    //OUTLETS
    
    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    //VARIABLES
    var assignmentID: Assignment?
    var index: Int?
    weak var delegate: AssignmentModuleDelegate?

    
    
    //Clears the finished Assignment and delegate it to the assignmentModuleVC
    @IBAction func finishTapped(_ sender: UIButton) {
        
        guard let hwID = self.assignmentID, let index = self.index else { return }
        
        self.delegate?.finishedAssignment(assignmentID: hwID, index: index, button: finishButton)
        
        
       
        

        
    }
}
