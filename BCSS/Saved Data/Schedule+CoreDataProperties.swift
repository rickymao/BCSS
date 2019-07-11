//
//  Schedule+CoreDataProperties.swift
//  
//
//  Created by Ricky Mao on 2019-07-11.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var block: Int16
    @NSManaged public var name: String?
    @NSManaged public var roomNumber: String?
    @NSManaged public var semester: Int16
    @NSManaged public var teacherName: String?

}
