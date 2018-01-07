//
//  PrepopulateData.swift
//  Wanderlist
//
//  Created by Robert Wong on 1/3/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import Foundation
import Firebase

struct PrepopulateTestData {
    let address: String
    let description: String
    let imageLink: String
    let name: String
    let notes: String
    //var ranking: String?

    init(address: String, description: String, imageLink: String, name: String, notes: String) {
        self.address = address
        self.description = description
        self.imageLink = imageLink
        self.name = name
        self.notes = notes
    }
    
    static func obtainData() -> [PrepopulateTestData] {
        var testData = [PrepopulateTestData]()
        let firebaseRef = Database.database()
        //let userReference = firebaseRef.reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/").child("Preset").child("New York City")
        firebaseRef.reference().child("Preset").child("New York City").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:NSObject] {
                for (key, value) in dictionary {
                    guard let address = value.value(forKey: "Address") as? String, let description = value.value(forKey: "Description") as? String, let imageLink = value.value(forKey: "Image") as? String, let name = value.value(forKey: "Name") as? String, let notes = value.value(forKey: "Notes") as? String else {
                        print("issue with address data")
                        return
                    }                    
                    let userData = PrepopulateTestData(address: address, description: description, imageLink: imageLink, name: name, notes: notes)
                    testData.append(userData)
                    print("Inside dictonary call: ", testData)
                }
            }
        })
        print("Before returning array: ", testData)
        return testData
    }
}
