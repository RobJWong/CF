//
//  CustomNavigationAnimator.swift
//  CustomTransitionAppV1
//
//  Created by Robert Wong on 10/9/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class CustomNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
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
        
        let snapshotView = toViewController.view.snapshotView(afterScreenUpdates: true)
        snapshotView?.frame = (fromViewController.view.frame).insetBy(dx: fromViewController.view.frame.size.width / 2, dy: fromViewController.view.frame.size.height / 2)
        transitionContext.containerView.addSubview(snapshotView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshotView?.frame = toViewControllerEndFrame
        }, completion: {
            finished in toViewController.view.frame = toViewControllerEndFrame
            snapshotView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
