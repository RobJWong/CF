//
//  ViewController.swift
//  PreferencesAppV1
//
//  Created by Robert Wong on 9/1/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func saveUserLogin(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        let testData = usernameTextField.text
        print(testData!)
        userDefaults.set(usernameTextField.text, forKey: "Username")
        userDefaults.set(passwordTextField.text, forKey: "Password")
        let alertController = UIAlertController(title: "Saved", message: ("Saved Data"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        clearForm()
    }

    func clearForm() {
        usernameTextField.text = nil
        passwordTextField.text = nil
    }

}
