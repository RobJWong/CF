//: Playground - noun: a place where people can play

import UIKit

let plistUrl = Bundle.main.url(forResource: "People", withExtension: "plist")
let fileManager = FileManager.default

var plistFormat = PropertyListSerialization.PropertyListFormat.xml

do {
    let plistData = try Data(contentsOf: plistUrl!)
    print(plistData)
    let people = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &plistFormat) as! [Dictionary<String, Any>]
    print (people)
    
    for person in people {
        print("First Name: \(person["First Name"]), Last Name: \(person["Last Name"]), Age: \(person["Age"])")
    }
    if let fName = people[0]["First Name"] {
        print("First Name for the first person: \(fName)")
    }
} catch {
    print("Error")
}

let anotherPerson = ["First Name" : "Mike", "Last Name" : " Holt", "Age" : 35] as [String : Any]
let yetAnotherPerson = ["First Name" : "Meg", "Last Name" : "Holt", "Age" : 35] as [String : Any]
let peopleArray = [anotherPerson, yetAnotherPerson]
let serializedData = try PropertyListSerialization.data(fromPropertyList: peopleArray, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
let document = try fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
let file = document.appendingPathComponent("more_people.plist")
try serializedData.write(to: file)
print(document)
