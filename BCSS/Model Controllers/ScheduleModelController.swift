//
//  ScheduleModelController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-11.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import Foundation
import CoreData

class ScheduleModelController {
    
    let persistenceManager = PersistenceManager.shared
    
    init() {}
    
    //Creates and initializes each block of a student's schedule
    func setupBlocks() {
        
        //Setup schedule
        let blockXsem1 = Blocks(context: persistenceManager.context)
        blockXsem1.blockX = true
        blockXsem1.block = 0
        blockXsem1.semester = 1
        
        let block1sem1 = Blocks(context: persistenceManager.context)
        block1sem1.block = 1
        block1sem1.semester = 1
        
        let block2sem1 = Blocks(context: persistenceManager.context)
        block2sem1.block = 2
        block2sem1.semester = 1
        
        let block3sem1 = Blocks(context: persistenceManager.context)
        block3sem1.block = 3
        block3sem1.semester = 1
        
        let block4sem1 = Blocks(context: persistenceManager.context)
        block4sem1.block = 4
        block4sem1.semester = 1
        
        let blockXsem2 = Blocks(context: persistenceManager.context)
        blockXsem2.blockX = true
        blockXsem2.block = 0
        blockXsem2.semester = 2
        
        let block1sem2 = Blocks(context: persistenceManager.context)
        block1sem2.block = 1
        block1sem2.semester = 2
        
        let block2sem2 = Blocks(context: persistenceManager.context)
        block2sem2.block = 2
        block2sem2.semester = 2
        
        let block3sem2 = Blocks(context: persistenceManager.context)
        block3sem2.block = 3
        block3sem2.semester = 2
        
        let block4sem2 = Blocks(context: persistenceManager.context)
        block4sem2.block = 4
        block4sem2.semester = 2
        
        persistenceManager.save()
        
        
        
    }
    //Gets blocks
    //Can get the blocks depending on semester and block number
    func getBlocks(semester: Int16?, block: Int16?) -> [Blocks] {
                let fetch: NSFetchRequest<Blocks>  = Blocks.fetchRequest()
                
        //Sets search for a block with semester and block int, then returns it if found
                guard let blockNum = block else {return [Blocks()]}
                guard let blockSem = semester else {return [Blocks()]}
                
                let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "block == %@" , blockNum as NSNumber), NSPredicate(format: "semester == %@" , blockSem as NSNumber)])
                
                     fetch.predicate = andPredicate
        do {
            
            let context = try persistenceManager.context.fetch(fetch)
            as [NSManagedObject]
                
                print(context)
                
            let schedule = context
            return schedule as! [Blocks]
                
                
        } catch {
            print(error)
        }
             return  [Blocks()]
    }
    
    //Gets blocks from coredata
    func getBlocks() -> [Blocks] {
          do {
            let context = try persistenceManager.context.fetch(Blocks.fetchRequest()) as [Blocks]
            return context
            } catch {
            print(error)
            return [Blocks()]
        }
    }
    
    //Gets blocks 
    //Can get the blocks depending on only semester
func getBlocks(semester: Int16?) -> [Blocks] {
        
        //Checking semester and filtering blocks
        if let sem = semester {
            switch sem {
                  case 1:
                    do {
                      let context = try persistenceManager.context.fetch(Blocks.fetchRequest()) as [Blocks]
                      return context.filter { (Blocks) -> Bool in
                          Blocks.semester == Int16(1);
                      }
                      } catch {
                          print(error)
                          return [Blocks()]
                      }
                case 2:
                  do {
                      let context = try persistenceManager.context.fetch(Blocks.fetchRequest()) as [Blocks]
                    return context.filter { (Blocks) -> Bool in
                        Blocks.semester == Int16(2);
                    }
                      } catch {
                          print(error)
                          return [Blocks()]
                      }
                
                  default:
                    do {
                      let context = try persistenceManager.context.fetch(Blocks.fetchRequest()) as [Blocks]
                      return context
                      } catch {
                          print(error)
                          return [Blocks()]
                      }
                      
                  }
        
        }
    
    
        return [Blocks()]
    
    
    }
    
    
    //Gets the current semester
    func getCurrentSemester(events: [Event]) -> Int{
        
        //Finding semester dates
        var semesterOneStart: Date = Date()
        var semesterOneEnd: Date = Date()
        var semesterTwoStart: Date = Date()
        var semesterTwoEnd: Date = Date()
        
        let formatter = DateFormatter()
        let dateController = DateController()
        
        
        //Looks for the start and end dates of each term
        for event in events {

            formatter.dateFormat = "yyyy MM dd"
            
            //Semester 1
            if event.title == "1st Day Of School" {

                if let formattedDate = formatter.date(from: event.date) {
                   semesterOneStart = dateController.standardizeDate(dateInput: formattedDate)
                    
                }

            } else if event.title == "Term 2 Ends" {
                
                if let formattedDate = formatter.date(from: event.date) {
                    semesterOneEnd = dateController.standardizeDate(dateInput: formattedDate)
                }
                
            } else if event.title == "Term 3 Starts" {
                
                if let formattedDate = formatter.date(from: event.date) {
                    semesterTwoStart = dateController.standardizeDate(dateInput: formattedDate)
                }
            } else if event.title == "Term 4 Ends" {
                
                if let formattedDate = formatter.date(from: event.date) {
                    semesterTwoEnd = dateController.standardizeDate(dateInput: formattedDate)
                }
            }

        }
        
        let today = dateController.standardizeDate(dateInput: Date())

        //Semester 1
        if today >= semesterOneStart && today <= semesterOneEnd {
        
            return 1

        //Semester 2
        } else if today >= semesterTwoStart && today <= semesterTwoEnd {
            
            return 2
            
        } else {
            
           return 0
        
        }
        
    }
    
    //Checks if it is Flex Day today
    func isFlexDay()-> Bool {
        
        let dateformatter = DateFormatter()
        let eventController = EventModelController()
        var events: [Event] = []
        
        //Getting events
        eventController.getEventCollection { (eventsDB) in
            if let newEvents = eventsDB {
                events = newEvents
            } else {
                events = []
            }
          }
        
        //Checking if there are Flex Time events today
              dateformatter.dateFormat = "yyyy MM dd"
              let today = dateformatter.string(from: Date())
              var flex = events
              
              flex = flex.filter { (Event) -> Bool in
                  Event.title == "Flex Time"
              }
              
              for flexday in flex {
                  
                  if flexday.date == today {
                      return true
                  }
                  
              }
              return false
        
    }
    
    
       func checkDayOne(events: [Event]) -> Bool {
         
         
         let dateformatter = DateFormatter()
         dateformatter.dateFormat = "yyyy MM dd"
         let today = dateformatter.string(from: Date())
         var days = events
         
         days = days.filter({ (Event) -> Bool in
             Event.title == "Day 1"
         })
         
         for day in days {
             
             if day.date == today {
                 return true
             }

         }
         return false
         
     }
    
    func checkDayTwo(events: [Event]) -> Bool {
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var days = events
        
        days = days.filter({ (Event) -> Bool in
            Event.title == "Day 2"
        })
        
        for day in days {
            
            if day.date == today {
                return true
            }
            
        }
        return false
        
    }

    
    func checkDayZero(events: [Event]) -> Bool {
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy MM dd"
        let today = dateformatter.string(from: Date())
        var days = events
        
        days = days.filter({ (Event) -> Bool in
            Event.title == "Day 0"
        })
        
        for day in days {
            
            if day.date == today {
                return true
            }
            
        }
        return false
        
    }
    
    
}
