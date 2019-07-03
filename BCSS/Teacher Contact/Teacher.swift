//
//  Teacher.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-21.
//  Copyright © 2018 Treeline. All rights reserved.
//

import Foundation

class Teacher {
    
    var teacherName: String
    var teacherEmail: String
    
    
    init(name: String, email: String) {
        self.teacherName = name
        self.teacherEmail = email
    }
    
    
    
}

enum Department {
    
    case Mathematics
    case Sciences
    case AppliedSkills
    case Athletics
    case ELL
    case English
    case LearningSupport
    case Languages
    case SocialStudies
    case StudentServices
    case Arts
    case Administration
    
}
