//
//  AuthenticationManager.swift
//  iChat
//
//  Created by Robert Wong on 9/26/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationManager: NSObject {
    static let sharedInstance = AuthenticationManager()
    
    var loggedIn = false
    var userName: String?
    var userID: String?
    
    func didLogIn(user: User) {
        AuthenticationManager.sharedInstance.userName = user.displayName
        AuthenticationManager.sharedInstance.loggedIn = true
        AuthenticationManager.sharedInstance.userID = user.uid
    }
}
