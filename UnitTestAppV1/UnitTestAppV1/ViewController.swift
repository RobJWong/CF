//
//  ViewController.swift
//  UnitTestAppV1
//
//  Created by Robert Wong on 11/4/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func validateButtonPressed(_ sender: UIButton) {
        guard let password = passwordField.text else {
            AlertBox.sendAlert(boxMessage: "Enter a password", presentingController: self)
            return
        }
        if (validatePasswordNumberReq(password: password)) {
            AlertBox.sendAlert(boxMessage: "Password accepted!", presentingController: self)
        }
    }
    
    @objc func validatePasswordNumberReq(password: String) -> Bool {
        if (validatePasswordCapitalReq(password: password)) {
            let numberCount = password.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if numberCount.count < 3 {
                AlertBox.sendAlert(boxMessage: "Password must have at least 3 numbers", presentingController: self)
                return false
            }
        }
        return true
    }
    
    @objc func validatePasswordCapitalReq(password: String) -> Bool {
        if (validatePasswordCharCountReq(password: password)) {
            var charCount = 0
            for character in password {
                let str = String(character)
                if str.lowercased() != str {
                    charCount = charCount + 1
                } else {
                    charCount = charCount + 0
                }
            }
            if charCount == 0 {
                AlertBox.sendAlert(boxMessage: "Password must have a capital letter", presentingController: self)
                return false
            }
        }
        return true
    }
    
    @objc func validatePasswordCharCountReq(password: String) -> Bool {
        if password.count == 0 {
            AlertBox.sendAlert(boxMessage: "Password cannot be empty", presentingController: self)
            return false
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
