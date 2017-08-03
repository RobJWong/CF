//
//  ViewController.swift
//  CustomControlDemo
//
//  Created by Robert Wong on 8/2/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func iconButtonTapped(_ sender: IconButton) {
        print("IconButton Tapped!")
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

