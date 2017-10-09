//
//  CustomInteractionAnimator.swift
//  CustomTransitionDemo
//
//  Created by Robert Wong on 10/6/17.
//  Copyright © 2017 CareerFoundy. All rights reserved.
//

import UIKit

class CustomInteractionAnimator: UIPercentDrivenInteractiveTransition {
    
    private var navigationController: UINavigationContoller!
    private var shouldCompleteTransition = false
    var transitionInProgress = false
    let customInteractionAnimator = CustomInteractionAnimator()
    
    func addToViewController(viewController: UIViewController) {
        navigationController = viewController.navigationController
        addGestureRecognizer(view: viewController.view)
    }
    
    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let translatedPoint = gestureRecognizer.translation(in: gestureRecognizer.view!.superview)
        let progress = translatedPoint.x / (gestureRecognizer.view!.superview?.frame.size.width)!
        
        switch gestureRecognizer.state {
        case .began:
            transitionInProgress = true
            navigationController.popViewController(animated: true)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled, .ended:
            transitionInProgress = false
            
            if !shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                cancel()
            } else {
                finish ()
            }
        default: break
        }
    }
    
    private func addGestureRecognizer(view: UIView) {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(CustomInteractionAnimator.handlePanGesture(gestureRecognizer:))))
    }
    

}
