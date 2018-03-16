//
//  ViewController.swift
//  CheapMessengerAppV1
//
//  Created by Robert Wong on 9/30/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailLogIn: UITextField!
    @IBOutlet weak var passwordLogIn: UITextField!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailLogIn.text, let password = passwordLogIn.text, email.characters.count > 0, password.characters.count > 0 else {
            AlertBox.sendAlert(boxMessage: "Enter a email and password", presentingController: self)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if error._code == AuthErrorCode.userNotFound.rawValue {
                    AlertBox.sendAlert(boxMessage: "There are no users with the specified account", presentingController: self)
                } else if error._code == AuthErrorCode.wrongPassword.rawValue {
                    AlertBox.sendAlert(boxMessage: "Incorrect username or password", presentingController: self)
                } else {
                    AlertBox.sendAlert(boxMessage: "Error: \(error.localizedDescription)", presentingController:  self)
                }
                print(error.localizedDescription)
                return
            }
            if let user = user {
                print(user.displayName)
                AuthenticationManager.sharedInstance.didLogin(user: user)
                self.performSegue(withIdentifier: "ShowUserList", sender: nil)
            }
        }
    }
}

