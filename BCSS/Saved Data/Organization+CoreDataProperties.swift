//
//  Organization+CoreDataProperties.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-07.
//  Copyright © 2018 Treeline. All rights reserved.
//
//

import Foundation
import CoreData


extension Organization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organization> {
        return NSFetchRequest<Organization>(entityName: "Organization")
    }

    @NSManaged public var name: String
    @NSManaged public var sponsor: String
    @NSManaged public var leader: String
    @NSManaged public var meeting: [NSDate]
    @NSManaged public var room: String
    @NSManaged public var descriptionClub: String

}
