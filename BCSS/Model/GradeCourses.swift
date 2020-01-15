//
//  GradeCourses.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-24.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import Foundation

class GradeCourse {
    
    //VARIABLES
    var Grade: String
    var courses: [String]
    
    init(Grade: String, courses: [String]) {
        self.Grade = Grade
        self.courses = courses
    }
}
