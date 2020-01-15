//
//  Teacher.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-21.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import Foundation

class Teacher {
    
    //VARIABLES
    var teacherName: String
    var teacherEmail: String
    var department: String?
    var type: String
    var homeroom: String?
    
    static var teachers: [Teacher] = []
    
    init(name: String, email: String, department: String?, type: String, homeroom: String?) {
        
        self.teacherName = name
        self.teacherEmail = email
        self.department = department
        self.type = type
        self.homeroom = homeroom
        
    }
    
    
    
}

enum Department {
    
    //The departments that each teacher would be under
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
