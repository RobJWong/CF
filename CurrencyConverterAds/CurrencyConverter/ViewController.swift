//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Robert Wong on 7/3/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import InMobiSDK

class ViewController: UIViewController, UITextFieldDelegate, IMBannerDelegate {
    
    //Mark : Properties
    @IBOutlet weak var poundLabel: UILabel!
    @IBOutlet weak var yenLabel: UILabel!
    @IBOutlet weak var euroLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    var banner: IMBanner?
    @IBOutlet weak var adBanner: IMBanner!
    
    let poundRate = 0.69
    let yenRate = 113.94
    let euroRate = 0.89
    var dollarAmount = 0.0
    
    //Mark : IBOutlets
    @IBAction func clearDollarAmount(_ sender: UIButton) {
        inputTextField.text = ""

    }
    
    @IBAction func convertCurrency(_ sender: UIButton) {
        if let amount = Double(inputTextField.text!) {
            dollarAmount = amount
        }
        
        poundLabel.text = "\(dollarAmount * poundRate)"
        yenLabel.text = "\(dollarAmount * yenRate)"
        euroLabel.text = "\(dollarAmount * euroRate)"
        dollarAmount = 0.0
    }
    
    //Mark : Function calls
    
    //Called when 'return' key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //Called when user taps outside the text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        banner = IMBanner(frame: CGRect(x: 0 , y: view.frame.height - 50, width: 320, height: 50), placementId: 1521204087376)
        banner?.delegate = self
        view.addSubview(banner!)
        banner?.load()
    }
    
    deinit {
        banner?.delegate = nil
    }

    //Mark : Delegates
    func bannerDidFinishLoading(_ banner: IMBanner!) {
        print("bannerDidFinishLoading")
    }
    
    func banner(_ banner: IMBanner!, didFailToLoadWithError error: IMRequestStatus!) {
        print("banner failed to load ad")
        print("Error : \(error?.description)")
    }
    
    func banner(_ banner: IMBanner!, didInteractWithParams params: [AnyHashable : Any]!) {
        print("didInteractWithParams")
    }
    
    func userWillLeaveApplication(from banner: IMBanner!) {
        print("userWillLeaveApplication")
    }
    
    func bannerWillPresentScreen(_ banner: IMBanner!) {
        print("bannerWillPresentScreen")
    }
    
    func bannerDidPresentScreen(_ banner: IMBanner!) {
        print("bannerDidPresentScreen")
    }
    
    func bannerWillDismissScreen(_ banner: IMBanner!) {
        print("bannerWillDismissScreen")
    }
    
    func bannerDidDismissScreen(_ banner: IMBanner!) {
        print("bannerDidDismissScreen")
    }
    
    func banner(_ banner: IMBanner!, rewardActionCompletedWithRewards rewards: [AnyHashable : Any]!) {
        print("rewardActionCompletedWithRewards")
    }
    
}

