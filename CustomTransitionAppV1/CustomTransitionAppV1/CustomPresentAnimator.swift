//
//  CustomPresentAnimator.swift
//  CustomTransitionAppV1
//
//  Created by Robert Wong on 10/8/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class CustomPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    //UIViewControllerAnimatedTransitioning protocol methods
    //Specifies how long the transition will take
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    //
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        
        let toViewControllerEndFrame = transitionContext.finalFrame(for: toViewController)
        var toViewControllerStartFrame = toViewControllerEndFrame
        toViewControllerStartFrame.origin.y -= UIScreen.main.bounds.height
        toViewController.view.frame = toViewControllerStartFrame
        
        transitionContext.containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.frame = toViewControllerEndFrame
            fromViewController.view.alpha = 0.5
        }, completion: {
            completed in
            transitionContext.completeTransition(true)
        })
    }
    
}
