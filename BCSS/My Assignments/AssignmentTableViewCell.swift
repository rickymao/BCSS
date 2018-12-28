//
//  AssignmentTableViewCell.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-04.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
