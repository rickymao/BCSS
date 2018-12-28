//
//  Work+CoreDataProperties.swift
//  
//
//  Created by Ricky Mao on 2018-11-11.
//
//

import Foundation
import CoreData


extension Work {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Work> {
        return NSFetchRequest<Work>(entityName: "Work")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: String?
    @NSManaged public var hours: Double
    @NSManaged public var extra: String?

}
