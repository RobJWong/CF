//
//  CustomPresentAnimator.swift
//  CustomTransitionDemo
//
//  Created by Robert Wong on 10/4/17.
//  Copyright © 2017 CareerFoundy. All rights reserved.
//  This object will be responsible for animating the transition and specifying how long it takes.

import UIKit

class CustomPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            else {
            return
        }
    
        let toViewControllerEndFrame = transitionContext.finalFrame(for: toViewController)
        var toViewControllerStartFrame = toViewControllerEndFrame
        toViewControllerStartFrame.origin.y -= UIScreen.main.bounds.height
        toViewController.view.frame = toViewControllerStartFrame
        
        transitionContext.containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            toViewController.view.frame = toViewControllerEndFrame
            fromViewController.view.alpha = 0.5
        }, completion: {
            completed in
            transitionContext.completeTransition(true)
        })
    }
}
