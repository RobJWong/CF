//
//  LoginViewController.swift
//  SplitViewDemo
//
//  Created by Robert Wong on 3/21/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginBool : loginChecker?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissViewController(_ sender: UIButton) {
        loginBool?.loggedIn = true
        dismiss(animated: true, completion: nil)
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
