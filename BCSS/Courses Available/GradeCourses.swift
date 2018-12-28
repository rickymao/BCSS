//
//  GradeCourses.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-24.
//  Copyright © 2018 Treeline. All rights reserved.
//

import Foundation

class GradeCourse {
    
    var Grade: String
    var courses: [String]
    
    init(Grade: String, courses: [String]) {
        self.Grade = Grade
        self.courses = courses
    }
}
