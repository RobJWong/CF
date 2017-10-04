//
//  SecondViewController.swift
//  AnimationAppV1
//
//  Created by Robert Wong on 10/3/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var likeCakeLabel: UILabel!
    @IBOutlet weak var cakePhoto: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.cakePhoto.image = UIImage(named: "cake1")
            self.cakePhoto.alpha = 1
            self.likeCakeLabel.alpha = 1
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cakePhotoTapped(recognizer:)))
        
        cakePhoto.gestureRecognizers = [tapGesture]
        cakePhoto.isUserInteractionEnabled = true
        //let tapRecognizer = UITapGestureRecognizer(target)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cakePhotoTapped(recognizer: UITapGestureRecognizer) {
        let randomCakeNumber = Int(arc4random_uniform(10) + 1)
        let cakeNumber = "cake" + "\(randomCakeNumber)"
        UIView.animate(withDuration: 1.5) {
            self.cakePhoto.alpha = 0
            self.cakePhoto.image = UIImage(named: String(cakeNumber))
            self.cakePhoto.alpha = 1
        }
        //self.cakePhoto.image = UIImage(named: String(cakeNumber))
    }

}
