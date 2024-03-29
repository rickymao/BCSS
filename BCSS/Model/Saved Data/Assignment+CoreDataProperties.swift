//
//  Assignment+CoreDataProperties.swift
//  
//
//  Created by Ricky Mao on 2020-01-08.
//
//

import Foundation
import CoreData


extension Assignment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assignment> {
        return NSFetchRequest<Assignment>(entityName: "Assignment")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var course: String?
    @NSManaged public var dueDate: String?
    @NSManaged public var notes: String?
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID

}
