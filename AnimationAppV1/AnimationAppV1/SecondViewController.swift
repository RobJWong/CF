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
            self.cakePhoto.image = UIImage(named: "cake")
            self.cakePhoto.alpha = 1
            self.likeCakeLabel.alpha = 1
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
