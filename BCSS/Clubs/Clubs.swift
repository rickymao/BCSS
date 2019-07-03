//
//  Clubs.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-18.
//  Copyright © 2018 Treeline. All rights reserved.
//

import Foundation

class Club {
  
    var name: String
    var teacher: String
    var room: String
    var clubOwner: String
    var description: String
    var meetingDates: [Date]
    var hasJoined: Bool?
    var email: [String]
    
    static var clubs: [Club] = []
    
    init(name: String, teacher: String, meeting: [Date], room: String, owner: String, desc: String, email: [String]) {
        self.name = name
        self.teacher = teacher
        self.meetingDates = meeting
        self.room = room
        self.clubOwner = owner
        self.description = desc
        self.email = email
    }
    
    
    
}
