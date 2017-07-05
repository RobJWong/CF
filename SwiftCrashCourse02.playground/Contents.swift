//: Playground - noun: a place where people can play

import UIKit

class Person {
    let name: String
    let age: Int
    let height: Int
    
    init(name: String, age: Int, height: Int)
    {
        self.name = name
        self.age = age
        self.height = height
    }
    
    func displayInfo() -> String {
        return ("Person: Name: \(name) Age: \(age) Height: \(height)")
    }
}

var PersonA = Person (name: "Rob", age: 25, height: 167)
print(PersonA.displayInfo())