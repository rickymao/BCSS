//
//  ClassTableViewCell.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-29.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //OUTLETS
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    

}
