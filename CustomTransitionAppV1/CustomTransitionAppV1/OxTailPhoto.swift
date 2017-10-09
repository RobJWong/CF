//
//  OxTailPhoto.swift
//  CustomTransitionAppV1
//
//  Created by Robert Wong on 10/8/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class OxTailPhoto: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if navigationController != nil {
            dismissButton.isHidden = true
        }
    }
    
    @IBAction func tapDismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
