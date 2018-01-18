//
//  SendingViewController.swift
//  WanderlistTestArea
//
//  Created by Robert Wong on 1/15/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(data: String)
}

class SendingViewController: UIViewController {
    
    @IBOutlet weak var dataTextField: UITextField!
    var user = TestObject()
    var delegate: DataSentDelegate? = nil

    @IBAction func sendButton(_ sender: Any) {
        if delegate != nil {
            if dataTextField.text != nil {
                let data = dataTextField.text
                delegate?.userDidEnterData(data: data!)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.setup(email: "123@gmail.com", name: "Test")
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
