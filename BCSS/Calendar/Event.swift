//
//  Event.swift
//  BCSS
//
//  Created by Ricky Mao on 2019-07-11.
//  Copyright © 2019 Treeline. All rights reserved.
//

import Foundation

class Event {
    
    var title: String
    var date: String
    var location: String
    var description: String
    var time: String
    
    
    
    static var events: [Event] = []
    
    init(title: String, date: String, location: String, description: String, time: String) {
        self.title = title
        self.date = date
        self.location = location
        self.description = description
        self.time = time
    }
    
    
}
