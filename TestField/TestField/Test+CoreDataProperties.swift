//
//  Test+CoreDataProperties.swift
//  TestField
//
//  Created by Robert Wong on 12/12/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension Test {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Test> {
        return NSFetchRequest<Test>(entityName: "Test")
    }

    @NSManaged public var testData: Bool

}
