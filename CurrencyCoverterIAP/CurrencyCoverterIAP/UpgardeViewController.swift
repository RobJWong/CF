//
//  UpgardeViewController.swift
//  CurrencyCoverterIAP
//
//  Created by Robert Wong on 3/19/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit

class UpgradeViewController: UIViewController {
    
    //MARK: Varibles and outlets
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        UpgradeManager.sharedInstance.priceForUpgrade { (price) in
            self.priceLabel.text = "$\(price)"
            self.upgradeButton.isEnabled = true
            self.restoreButton.isEnabled = true
        }
    }
    
    //MARK: IBActions
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        print("Done Pressed")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upgradeButtonTapped(_ sender: AnyObject) {
        print("Upgrade Pressed")
        UpgradeManager.sharedInstance.upgrade { (succeeded) -> (Void) in
            if succeeded {
                let alertController = UIAlertController(title: "Upgraded!", message: "Thanks for upgrading, you now have the other currency conversions", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                print("Upgrade did not work")
            }
            print("Am I here?")
        }
         print("Am I here? Part 2?")
    }
    
    @IBAction func restorePurchasesButtonTapped(_ sender: AnyObject) {
        UpgradeManager.sharedInstance.restorePurchases { (succeeded) -> (Void) in
            if succeeded {
                print("Restore Pressed")
                let alertController = UIAlertController(title: "Restored!", message: "Thank you againf for previously purchasing the upgrade!", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
