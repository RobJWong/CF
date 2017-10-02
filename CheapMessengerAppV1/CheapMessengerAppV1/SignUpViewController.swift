//
//  SignUpViewController.swift
//  CheapMessengerAppV1
//
//  Created by Robert Wong on 9/30/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let email = signUpEmail.text, let password = signUpPassword.text, email.characters.count > 0, password.characters.count > 0
            else {
                AlertBox.sendAlert(boxMessage: "Enter a name, email and a password", presentingController: self)
                return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if error._code == AuthErrorCode.invalidEmail.rawValue {
                    AlertBox.sendAlert(boxMessage:"Enter a valid email.", presentingController: self)
                } else if error._code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    AlertBox.sendAlert(boxMessage: "Email already in use.", presentingController: self)
                } else {
                    AlertBox.sendAlert(boxMessage: "Error: \(error.localizedDescription)", presentingController: self)
                }
                print(error.localizedDescription)
                return
            }
            if let user = user {
                self.setUserName(user: user)
            }
        }
    }
    
    func setUserName (user: User) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.commitChanges() {(error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            AuthenticationManager.sharedInstance.didLogIn(user: user)
            self.performSegue(withIdentifier: "ShowUserList", sender: nil)
        }
    }

}
