//
//  ViewController.swift
//  GestureAppV1
//
//  Created by Robert Wong on 8/2/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gestureLayout: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    //var gestureLayout: UIView!
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        print("Handle Pan gesture caught")
        actionLabel.text = "Pan Gesture"
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        print("Handle Tap gesture caught")
        actionLabel.text = "Tap Gesture"
    }
    
    func handleRotation(recognizer: UIRotationGestureRecognizer) {
        print("Handle Rotation gesture caught")
        actionLabel.text = "Rotation Gesture"
    }
    
    func handlePinch(recognizer : UIPinchGestureRecognizer) {
        print("Handle Pinch gesture caught")
        actionLabel.text = "Pinch Gesture"
    }
    
    func handleEdgePan(recognizer: UIScreenEdgePanGestureRecognizer) {
        print("Handle Edge Pan gesture caught")
        actionLabel.text = "Edge Gesture"
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        print("Handle Long Press gesture caught")
        actionLabel.text = "Long Press Gesture"
    }
    
    func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        print("Handle Swipes gesture caught")
        actionLabel.text = "Swipe Gesture"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeGesture.numberOfTouchesRequired = 1
        swipeGesture.direction = .up
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(recognizer:)))
        edgePanGesture.edges = .left
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        panGesture.require(toFail: swipeGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(recognizer:)))
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(recognizer:)))
        
        gestureLayout.gestureRecognizers = [panGesture, tapGesture, rotateGesture, pinchGesture, swipeGesture, edgePanGesture, longPressGesture]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

