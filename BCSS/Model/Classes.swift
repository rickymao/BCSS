//
//  Classes.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-28.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import Foundation

class Classes {
    
    //VARIABLES
    var className: String?
    var teacherName: String?
    var RoomNumber: String?
    var block: Int?
    var blockX: Bool = false
    var semester: Int?
    
    var className2: String?
    var teacherName2: String?
    var RoomNumber2: String?
    
    init(classes: String, teacher: String, room: String?, block: Int, semester: Int) {
        self.className = classes
        self.teacherName = teacher
        self.RoomNumber = room
        self.block = block
        self.semester = semester
    }
    
    
}
