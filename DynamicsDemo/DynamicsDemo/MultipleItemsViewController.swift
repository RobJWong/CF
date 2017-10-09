//
//  MultipleItemsViewController.swift
//  DynamicsDemo
//
//  Created by Hesham Abd-Elmegid on 6/23/16.
//  Copyright © 2016 CareerFoundy. All rights reserved.
//

import UIKit

class MultipleItemsViewController: UIViewController {
    
    let gravityBehavior = UIGravityBehavior()
    let collisionBehavior = UICollisionBehavior()
    let dynamicItemBehavior = UIDynamicItemBehavior()
    
    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.addBehavior(gravityBehavior)
        
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        
        dynamicItemBehavior.elasticity = 0.6
        animator.addBehavior(dynamicItemBehavior)
    }
    
    func addDynamicBehaviorsToView(view: UIView) {
        gravityBehavior.addItem(view)
        collisionBehavior.addItem(view)
        dynamicItemBehavior.addItem(view)
    }
    
    func createView() -> UIView {
        let x = randomNumber(min: 0, max: view.bounds.width)
        let frame = CGRect(x: CGFloat(x), y: 0, width: 40, height: 40)
        let squareView = UIView(frame: frame)
        squareView.backgroundColor = randomColor()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MultipleItemsViewController.squareViewTapped(gestureRecognizer:)))
        squareView.addGestureRecognizer(tapGestureRecognizer)
        return squareView
    }
    
    func randomNumber(min: CGFloat, max: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UInt32.max) * (max - min) + min
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: randomNumber(min: 0, max: 1), green: randomNumber(min:0, max: 1), blue: randomNumber(min: 0, max: 1), alpha: 1)
    }
    
    @objc func squareViewTapped(gestureRecognizer: UITapGestureRecognizer) {
        if let view = gestureRecognizer.view {
            let pushBehavior = UIPushBehavior(items: [view], mode: .instantaneous)
            pushBehavior.pushDirection = CGVector(dx: randomNumber(min: -4, max: 4), dy: randomNumber(min: -4, max: 4))
            animator.addBehavior(pushBehavior)
        }
    }

    @IBAction func addViewButtonTapped(_ sender: AnyObject) {
        let squareView = createView()
        view.addSubview(squareView)
        addDynamicBehaviorsToView(view: squareView)
    }
}
