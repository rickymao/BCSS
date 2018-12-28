//
//  Sports.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-19.
//  Copyright © 2018 Treeline. All rights reserved.
//

import Foundation

class Sports {
    
    var name: String
    var coach: [String]
    var teacher: String
    var season: String
    var meeting: Date
    var grade: String
    var email: String
    
    init(name: String, coach: [String], teacher: String, season: String, meeting: Date, grade: String, email: String) {
        
        self.name = name
        self.coach = coach
        self.season = season
        self.meeting = meeting
        self.teacher = teacher
        self.grade = grade
        self.email = email
    }
    
    
}
