//
//  StudentData.swift
//  KeyedArchiverAppV1
//
//  Created by Robert Wong on 9/11/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class StudentData: NSObject, NSCoding {
    
    let studentName: String
    let grade: String
    let subject: String
    let age: Int
    
    init(studentName: String, grade: String, subject: String, age: Int) {
        self.studentName = studentName
        self.grade = grade
        self.subject = subject
        self.age = age
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let studentName = aDecoder.decodeObject(forKey: "StudentName") as? String,
            let grade = aDecoder.decodeObject(forKey: "Grade") as? String,
            let subject = aDecoder.decodeObject(forKey: "Subject") as? String
            else { return nil }
        
        self.init(studentName: studentName, grade: grade, subject: subject, age: aDecoder.decodeInteger(forKey: "Age"))
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.studentName, forKey: "StudentName")
        aCoder.encode(self.grade, forKey: "Grade")
        aCoder.encode(self.subject, forKey: "Subject")
        aCoder.encode(self.age, forKey: "Age")
    }
    
    override var description: String {
        return "\(studentName) \(grade) \(subject) Age: \(age)"
    }
    
}
