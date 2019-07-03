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
    var coach: String
    var teacher: String
    var season: String
    var email: String
    
    static var sports: [Sports] = []
    
    init(name: String, coach: String, teacher: String, season: String, email: String) {
        
        self.name = name
        self.coach = coach
        self.season = season
        self.teacher = teacher
        self.email = email
    }
    
    
}
