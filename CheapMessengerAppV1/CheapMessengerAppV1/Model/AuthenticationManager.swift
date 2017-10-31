//
//  AuthenticationManager.swift
//  CheapMessengerAppV1
//
//  Created by Robert Wong on 10/26/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationManager: NSObject {
    static let sharedInstance = AuthenticationManager()
    
    var loggedIn = false
    var userName : String?
    var userID : String?
    var email: String?
    
    func didLogin(user: User){
        AuthenticationManager.sharedInstance.userName = user.displayName
        AuthenticationManager.sharedInstance.userID = user.uid
        AuthenticationManager.sharedInstance.loggedIn = true
        AuthenticationManager.sharedInstance.email = email
    }
    
}
