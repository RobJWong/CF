//
//  SignUpViewController.swift
//  CheapMessengerAppV1
//
//  Created by Robert Wong on 9/30/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase
import Flurry_iOS_SDK

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpName: UITextField!
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let email = signUpEmail.text, let password = signUpPassword.text, let name = signUpName.text, email.characters.count > 0, password.characters.count > 0, name.characters.count > 0
            else {
                AlertBox.sendAlert(boxMessage: "Enter a name, email and a password", presentingController: self)
                return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            Flurry.logEvent("User signed in")
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
            
            guard let uid = user?.uid else {
                return
            }
            let ref = Database.database().reference()
            let userReference = ref.child("users").child(uid)
            
            let values = ["name": name, "email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges() {(error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        AuthenticationManager.sharedInstance.didLogin(user: user)
                        self.performSegue(withIdentifier: "ShowUserList", sender: nil)
                    }
                }
            })
        }
    }
}
