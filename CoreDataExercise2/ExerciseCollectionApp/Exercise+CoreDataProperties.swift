//
//  Exercise+CoreDataProperties.swift
//  ExerciseCollectionApp
//
//  Created by Robert Wong on 3/14/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var count: Int32

}
