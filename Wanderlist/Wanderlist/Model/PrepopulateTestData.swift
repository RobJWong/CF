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
    var address: String?
    var description: String?
    var imageLink: String?
    var name: String?
    var notes: String?
    //var ranking: String?

    init() {
        let testData = [PrepopulateTestData]()
        let firebaseRef = Database.database()
        let userReference = firebaseRef.reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/").child("Preset").child("New York City")
        firebaseRef.reference().child("Preset").child("New York City").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                for (key, value) in dictionary {
                    guard let address = value.value(forKey: "Address"), let description = value.value(forKey: "Description"), let imageLink = value.value(forKey: "Image"), let name = value.value(forKey: "Name"), let note = value.value(forKey: "Notes") else {
                        print("Error in trying to obtain Firebase values")
                        return
                    }
                    print(address, description, imageLink, name, note)
                }
            }
        })
    }
}
