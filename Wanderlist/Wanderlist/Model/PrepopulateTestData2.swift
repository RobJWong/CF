//
//  PrepopulateTestData2.swift
//  Wanderlist
//
//  Created by Robert Wong on 1/3/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import Foundation
import Firebase

class PrepopulationTestData2 {
    
    //var address, description, name, notes: String?
    //let address, description, name, notes: String
    
//    init(address: String, description: String, name: String, notes: String) {
//
//        self.address = address
//        self.description = description
//        self.name = name
//        self.notes = notes
//    }
    
    static func obtainFirebaseData () {
        let storedData = [PrepopulationTestData2]()
        let firebaseRef = Database.database()
        let userReference = firebaseRef.reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/").child("Preset").child("New York City")
        firebaseRef.reference().child("Preset").child("New York City").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                print("inside firebase call: " , dictionary)
            }
        })
    }
}
