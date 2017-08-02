//
//  FirstViewController.swift
//  GestureRecognizerDemo
//
//  Created by Robert Wong on 8/1/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var squareView: UIView!
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let translationInView = recognizer.translation(in: self.view)
        recognizer.view!.center = CGPoint(x:view.center.x + translationInView.x, y: view.center.y + translationInView.y)
    }

    override func viewDidLoad() {
        squareView = UIView(frame: CGRect(x: 150, y: 250, width: 100, height: 100))
        squareView.backgroundColor = .blue
        view.addSubview(squareView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        squareView.addGestureRecognizer(panGesture)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

