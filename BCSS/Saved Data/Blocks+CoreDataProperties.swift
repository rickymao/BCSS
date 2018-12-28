//
//  Blocks+CoreDataProperties.swift
//  
//
//  Created by Ricky Mao on 2018-12-08.
//
//

import Foundation
import CoreData


extension Blocks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Blocks> {
        return NSFetchRequest<Blocks>(entityName: "Blocks")
    }

    @NSManaged public var block: Int16
    @NSManaged public var blockX: Bool
    @NSManaged public var nameClass: String?
    @NSManaged public var nameClass2: String?
    @NSManaged public var nameTeacher: String?
    @NSManaged public var nameTeacher2: String?
    @NSManaged public var roomNumber: String?
    @NSManaged public var roomNumber2: String?
    @NSManaged public var semester: Int16

}
