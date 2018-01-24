//
//  UserData.swift
//  Travels
//
//  Created by Robert Wong on 1/13/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import Foundation
import Firebase

class UserData {
    //static let sharedInstance = UserData()
    
    var loggedIn = false
    var userID : String?
    var email: String?
    var currentCitySelection: String?
    var currentDate: [String]?
    var userName: String?
    //var currentCityData: [NSObject]?
    
    func didLogin(user: User){
        self.userID = user.uid
        self.loggedIn = true
        self.email = user.email
        self.userName = user.displayName
    }
    
}