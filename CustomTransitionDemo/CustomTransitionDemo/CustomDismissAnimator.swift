//
//  CustomDismissAnimator.swift
//  CustomTransitionDemo
//
//  Created by Robert Wong on 10/6/17.
//  Copyright © 2017 CareerFoundy. All rights reserved.
//

import UIKit

class CustomDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                return
    }
        
        var fromViewControllerEndFrame = fromViewController.view.frame
        fromViewControllerEndFrame.origin.y -= UIScreen.main.bounds.height
        
        transitionContext.containerView.addSubview(toViewController.view)
        transitionContext.containerView.sendSubview(toBack: toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = fromViewControllerEndFrame
            toViewController.view.alpha = 1
        }, completion: {
            completed in
            transitionContext.completeTransition(true)
        })
    }
}
