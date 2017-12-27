//
//  ViewController.swift
//  TestField
//
//  Created by Robert Wong on 11/20/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var userTestObject = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userTestObject.email = "testEmail@gmail.com"
        print(userTestObject.email)
        print(userTestObject.testData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

