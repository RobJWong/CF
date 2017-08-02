//
//  SecondViewController.swift
//  GestureRecognizerDemo
//
//  Created by Robert Wong on 8/1/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
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

