//
//  DetailsViewController.swift
//  DebuggingExercise
//
//  Created by Hesham Abd-Elmegid on 7/19/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var takeMeBackButton: UIButton!
    @IBOutlet weak var descriptionItemLabel: UILabel!

    var item: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = item {
            descriptionItemLabel.text = "You selected \(item)"
        } else {
            descriptionItemLabel.text = "Error setting item label"
        }
        //descriptionItemLabel.text = "You selected \(item!)"
        takeMeBackButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        //takeMeBackButton.addTarget(self, action: selector("buttonTapped:"), for: .touchUpInside)

    }
    
    @objc func buttonTapped(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}
