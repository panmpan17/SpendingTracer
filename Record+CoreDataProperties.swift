//
//  Record+CoreDataProperties.swift
//  Easy Record
//
//  Created by Michael Pan on 11/14/17Tuesday.
//  Copyright © 2017 Michael Pan. All rights reserved.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var describe: String?
    @NSManaged public var number: Int16
    @NSManaged public var type: String?

}
