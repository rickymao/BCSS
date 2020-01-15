//
//  CoreClub+CoreDataProperties.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-07.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreClub {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreClub> {
        return NSFetchRequest<CoreClub>(entityName: "CoreClub")
    }

    @NSManaged public var name: String
    @NSManaged public var sponsor: String
    @NSManaged public var leader: String
    @NSManaged public var meeting: [NSDate]
    @NSManaged public var room: String
    @NSManaged public var descriptionClub: String

}
