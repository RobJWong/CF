//
//  Person.swift
//  KeyedArchiverDemo
//
//  Created by Robert Wong on 9/5/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    
    let firstName: String
    let lastName: String
    let age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    override var description: String {
        return ("\(firstName) \(lastName) \(age)")
    }
    
    required convenience init? (coder aDecoder: NSCoder) {
        guard let firstName = aDecoder.decodeObject(forKey: "firstName") as? String,
            let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
            else { return nil }
        self.init(firstName: firstName, lastName: lastName, age: aDecoder.decodeInteger(forKey: "age"))
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.age, forKey: "age")
    }
}
