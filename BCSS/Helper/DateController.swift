//
//  DateController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-11.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import Foundation

class DateController {
    
    init() {}
    
    //Checks if today is a school day
    func checkSchoolDay(completion: @escaping (Bool) -> Void) {
        
        var isSchoolDay = false
        var eventsToday: [Event] = []
        let eventController = EventModelController()

        //Checks if today is a school day
       eventController.getTodaysEvents(completion: { (eventsDB) in
        
        if let newEvents = eventsDB {
            for event in newEvents {
                if event.title == "Day 1" || event.title == "Day 2" {
                    
        
                    isSchoolDay = true
                    
                } else {
                    
                    isSchoolDay = false
                    
                }
            }
        }
        completion(isSchoolDay)
          })
        }
    
    //return dates that can be easily compared for boolean expression
    func standardizeDate(dateInput: Date) -> Date {
        
        let componentDate = Calendar.current.dateComponents([.year, .month, .day], from: dateInput)

        let actualDate = Calendar.current.date(from: componentDate)
        
        if let unwrappedDate = actualDate {
            return unwrappedDate
        } else {
            return Date()
        }
        
        
        
    }
    
    
    
}
