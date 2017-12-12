//
//  User+CoreDataProperties.swift
//  Wanderlist
//
//  Created by Robert Wong on 12/12/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstTimeUser: Bool

}
