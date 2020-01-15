//
//  WorkModelController.swift
//  BCSS
//
//  Created by Ricky Mao on 2020-01-12.
//  Copyright © 2020 Ricky Mao. All rights reserved.
//

import Foundation
import CoreData

class WorkModelController {
    
    private var workExp: Work?
    let persistenceManager = PersistenceManager.shared
    
    init() {
        
    }
    
    init(work: Work) {
        workExp = work
    }
    
    //Gets user's work exp. hours from core data
    func getWorkHours() -> [Work] {
        
        var jobs: [Work] = []
        
        do {
            let context = try persistenceManager.context.fetch(Work.fetchRequest()) as [Work]
            jobs = context

            
        } catch {
            print(error)
        }
        return jobs
    }
    
    //Deletes work exp. hours
    func deleteWorkHours(works: Work) {
        persistenceManager.context.delete(works)
        persistenceManager.save()
    }
    
    //Adds new work exp. to core data
    func addWork(name: String, date: String, hours: Double, description: String) -> Work {
        
        let work = Work(context: persistenceManager.context)
        work.date = date
        work.name = name
        work.hours = hours
        work.extra = description
        persistenceManager.save()
        
        return work

    }
    
    
    
    
    
}
