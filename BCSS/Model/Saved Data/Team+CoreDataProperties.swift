//
//  Team+CoreDataProperties.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-10-07.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Teams")
    }

    @NSManaged public var sport: String
    @NSManaged public var coach: String
    @NSManaged public var season: String
    @NSManaged public var teacher: String
    @NSManaged public var practiceTime: NSDate
    @NSManaged public var grade: String


}
