//
//  BlockTableViewCell.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-12-08.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class BlockTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var oneCourseName: UILabel!
    @IBOutlet weak var oneTeacherName: UILabel!
    
    @IBOutlet weak var twoCourseName: UILabel!
    @IBOutlet weak var twoTeacherName: UILabel!
    
}
