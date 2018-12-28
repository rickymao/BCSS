//
//  Homework+CoreDataProperties.swift
//  
//
//  Created by Ricky Mao on 2018-11-11.
//
//

import Foundation
import CoreData


extension Homework {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Homework> {
        return NSFetchRequest<Homework>(entityName: "Homework")
    }

    @NSManaged public var title: String?
    @NSManaged public var course: String?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var completed: Bool
    @NSManaged public var notes: String?

}
