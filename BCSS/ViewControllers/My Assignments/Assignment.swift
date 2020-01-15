//
//  Assignment.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-09-04.
//  Copyright © 2018 Treeline. All rights reserved.
//

import Foundation

class Assignment {
    
    var title: String
    var course: String
    var dueDate: String
    var completion: Bool
    var notes: String?
    
    init(title: String, course: String, dueDate: String, notes: String?) {
        self.title = title
        self.course = course
        self.dueDate = dueDate
        self.notes = notes
        self.completion = false
    }
    
    
    
}
