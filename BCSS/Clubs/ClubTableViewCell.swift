//
//  ClubTableViewCell.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-26.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit

class ClubTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var club: Club?
    @IBOutlet weak var clubName: UILabel!
    
 
    
}
