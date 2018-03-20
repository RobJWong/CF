//
//  ViewController.swift
//  CurrencyCoverterIAP
//
//  Created by Robert Wong on 3/19/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Variables & Outlets
    
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var euroLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var cnyLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var audLabel: UILabel!
    @IBOutlet weak var inrLabel: UILabel!
    @IBOutlet weak var mxnLabel: UILabel!
    @IBOutlet weak var krnLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    let cadRate = 1.30
    let euroRate = 0.80
    let gbpRate = 0.71
    let jpyRate = 106.07
    let cnyRate = 6.33
    let chfRate = 0.95
    let audRate = 1.29
    let inrRate = 65.27
    let mxnRate = 18.72
    let krnRate = 1073.26
    let bitcoin = 8425.00
    var dollarAmount = 0.0
    
    //MARK: IBActions
    @IBAction func clearDollarAmount(_ sender: UIButton) {
        inputTextField.text = ""
    }
    
    @IBAction func convertCurrency(_ sender: UIButton) {
        if let amount = Double(inputTextField.text!) {
            dollarAmount = amount
        }
        cadLabel.text = "\(dollarAmount * cadRate)"
        euroLabel.text = "\(dollarAmount * euroRate)"
        gbpLabel.text = "\(dollarAmount * gbpRate)"
        
        if !UpgradeManager.sharedInstance.hasUpgraded() {
            let alertController = UIAlertController(title: "Upgrade",
                                                    message: "Please upgrade to be able to get more currency conversions)",
                                                    preferredStyle: .alert)
            
            let upgradeAction = UIAlertAction(title: "Upgrade",
                                              style: .default,
                                              handler: { (action) in
                                                self.performSegue(withIdentifier: "ShowUpgradeViewController", sender: nil)
            })
            
            let laterAction = UIAlertAction(title: "Later",
                                            style: .cancel,
                                            handler: nil)
            
            alertController.addAction(upgradeAction)
            alertController.addAction(laterAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            jpyLabel.text = "\(dollarAmount * jpyRate)"
            cnyLabel.text = "\(dollarAmount * cnyRate)"
            chfLabel.text = "\(dollarAmount * chfRate)"
            audLabel.text = "\(dollarAmount * audRate)"
            inrLabel.text = "\(dollarAmount * inrRate)"
            mxnLabel.text = "\(dollarAmount * mxnRate)"
            krnLabel.text = "\(dollarAmount * krnRate)"
            bitcoinLabel.text = "\(dollarAmount * bitcoin)"
        }
        dollarAmount = 0.0
    }
    
    //MARK: Delegates
    
    //Called when 'return' key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Called when user taps outside the text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: Other functions
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
}

