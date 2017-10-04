//
//  ViewController.swift
//  AnimationAppV1
//
//  Created by Robert Wong on 10/3/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var cakeLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.yesButton.alpha = 1
            self.noButton.alpha = 1
            self.cakeLabel.alpha = 1
        })
    }
    
    @IBAction func noButtonPressed(_ sender: UIButton) {
        sender.shake(duration: 0.5, values: [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIButton {
    
    func shake(duration: TimeInterval = 0.5, values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        layer.add(animation, forKey: "shakeButton")
    }
    
}

