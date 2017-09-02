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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        usernameData.text = userDefaults.object(forKey: "Username") as? String
        passwordData.text = userDefaults.object(forKey: "Password") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
