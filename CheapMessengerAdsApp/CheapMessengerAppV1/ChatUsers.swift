//
//  ChatUsers.swift
//  CheapMessengerAppV1
//
//  Created by Robert Wong on 10/2/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct ChatUser {
    
    var uid: String
    var email: String
}

extension ChatUser: Equatable {
    static func == (lhs: ChatUser, rhs: ChatUser) -> Bool {
        return lhs.uid == rhs.uid
    }
}

extension ChatUser {
    static func create(from snapshot: DataSnapshot) -> ChatUser? {
        let uid = snapshot.key
        
        if let value = snapshot.value as? [String:AnyObject],
            let email = value["email"] as? String {
            let chatUser = ChatUser(uid: uid, email: email)
            return chatUser
        }
        return nil
    }
}
