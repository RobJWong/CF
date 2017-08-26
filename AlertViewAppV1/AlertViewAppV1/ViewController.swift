//
//  ViewController.swift
//  AlertViewAppV1
//
//  Created by Robert Wong on 8/24/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var outcomeLabel: UILabel!
    @IBOutlet weak var newOutcome: UITextField!
    
    var eightBall = EightBall()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func random8BallGenerator(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Magic 8 Box", message: "Shake?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) {
            (alert) in
                print("User tapped No")
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            (alert) in
                print("User tapped Yes")
            let randomNumber = Int(arc4random_uniform(UInt32((self.eightBall.outcomes.count))+1))
            print (self.eightBall.outcomes.count)
            self.outcomeLabel.text = ("\(self.eightBall.outcomes[randomNumber])")
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        alertController.popoverPresentationController?.sourceRect = sender.frame
        alertController.popoverPresentationController?.sourceView = view
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddNewOptionController")
        viewController.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = viewController.popoverPresentationController!
        popover.barButtonItem = sender
        popover.delegate = self
        present(viewController, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ViewController.dismissViewController))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = doneButton
        return navigationController
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }

}
