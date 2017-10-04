//
//  ViewController.swift
//  AnimationsDemo
//
//  Created by Hesham Abd-Elmegid on 6/16/16.
//  Copyright © 2016 CareerFoundy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 15, options: [], animations: {
            self.textFieldLeadingConstraint.constant = 16
            self.textFieldTrailingConstraint.constant = 16
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.nameTextField.becomeFirstResponder()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldLeadingConstraint.constant = view.bounds.width
        textFieldTrailingConstraint.constant = -view.bounds.width
        nameTextField.alpha = 1
    }
    
    @IBAction func greetButtonTapped(_ sender: AnyObject) {
        if let name = nameTextField.text, !name.isEmpty {
            let greeting = "Hello " + name
            let alertController = UIAlertController(title: nil, message: greeting, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        } else {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeCubic], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
                    self.textFieldLeadingConstraint.constant  = 40
                    self.textFieldTrailingConstraint.constant = 0
                    self.view.layoutIfNeeded()
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4, animations: {
                    self.textFieldLeadingConstraint.constant  = 0
                    self.textFieldTrailingConstraint.constant = 40
                    self.view.layoutIfNeeded()
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
                    self.textFieldLeadingConstraint.constant  = 16
                    self.textFieldTrailingConstraint.constant = 16
                    self.view.layoutIfNeeded()
                })
            }, completion: nil)
        }
    }
}
