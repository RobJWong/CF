//
//  TestObject.swift
//  WanderlistTestArea
//
//  Created by Robert Wong on 1/15/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import Foundation

class TestObject: NSObject {
    var email: String?
    var name: String?
    
    func setup(email: String, name: String) {
        self.email = email
        self.name = name
    }
}
