//
//  ViewController.swift
//  DynamicViewAppV1
//
//  Created by Robert Wong on 10/9/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var circleDropNavButton: UIBarButtonItem!
    
    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.view)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func circleDrop(_ sender: UIBarButtonItem) {
        circleDropNavButton.isEnabled = false
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let circle = UIView(frame: frame)
        circle.center = self.view.center
        circle.layer.cornerRadius = 25
        circle.backgroundColor = UIColor.blue
        circle.clipsToBounds = true
        
        self.view.addSubview(circle)
        
        let gravityBehavior = UIGravityBehavior(items: [circle])
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [circle])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        
        let dynamicItemBehavior = UIDynamicItemBehavior(items: [circle])
        dynamicItemBehavior.elasticity = 0.6
        animator.addBehavior(dynamicItemBehavior)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.circleViewTapped(gestureRecognizer:)))
        circle.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func randomNumber(min: CGFloat, max: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UInt32.max) * (max - min) + min
    }
    
    @objc func circleViewTapped(gestureRecognizer: UITapGestureRecognizer) {
        if let view = gestureRecognizer.view {
            let bounceForce = UIPushBehavior(items: [view], mode: .instantaneous)
            bounceForce.pushDirection = CGVector(dx: randomNumber(min: -10, max: 10), dy: randomNumber(min: -10, max: 10))
            animator.addBehavior(bounceForce)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

