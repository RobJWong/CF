//
//  PrepopulateTestData3.swift
//  Wanderlist
//
//  Created by Robert Wong on 1/5/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import Foundation

class PrepopulateTestData3 {
    
    var address: String?
    var description: String?
    var imageLink: String?
    var name: String?
    var notes: String?

    init(address: String, description: String, imageLink: String, name: String, notes: String) {
        self.address = address
        self.description = description
        self.imageLink = imageLink
        self.name = name
        self.notes = notes
    }
}
