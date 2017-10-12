//
//  ShowDataViewController.swift
//  PreferencesAppV1
//
//  Created by Robert Wong on 9/1/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ShowDataViewController: UIViewController {

    @IBOutlet weak var passwordData: UILabel!
    @IBOutlet weak var usernameData: UILabel!
    @IBOutlet weak var showEmailData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let userDefaults = UserDefaults.standard
        let email = userDefaults.object(forKey: "Email") as? String
        let username = userDefaults.object(forKey: "Username") as? String
        let password = userDefaults.object(forKey: "Password") as? String
        
        let catToggle = userDefaults.object(forKey: "CatToggle") as? Bool
        print(catToggle)
        
        if email == nil || email!.isEmpty {
            showEmailData.text = "-No saved data-"
        } else {
            showEmailData.text = userDefaults.object(forKey: "Email") as? String
        }
        
        if username == nil || username!.isEmpty {
            usernameData.text = "-No saved data-"
        } else {
            usernameData.text = userDefaults.object(forKey: "Username") as? String
        }
        
        if password == nil || password!.isEmpty {
            passwordData.text = "-No saved data-"
        } else {
            passwordData.text = userDefaults.object(forKey: "Password") as? String
        }

    }

}
