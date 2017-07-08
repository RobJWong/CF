//
//  DataSet.swift
//  ExerciseTableApp
//
//  Created by Robert Wong on 7/7/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class DataSet {
    var name: String
    let date: String
    let nameSet: [String] = ["David","Susan","Juan","Kate","Joe","Jen"]
    
    init() {
        let idx = arc4random_uniform(UInt32(nameSet.count))
        let randomName = nameSet[Int(idx)]
        self.name = randomName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.date = formatter.string(from: Date())
    }
}
