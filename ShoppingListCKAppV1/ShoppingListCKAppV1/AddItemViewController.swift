//
//  AddItemViewController.swift
//  ShoppingListCKAppV1
//
//  Created by Robert Wong on 9/27/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CloudKit
import SVProgressHUD

protocol AddItemViewControllerDelegate {
    func controller(controller: AddItemViewController, didAddItem item: CKRecord)
    func controller(controller: AddItemViewController, didUpdateItem item: CKRecord)
}

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberStepper: UIStepper!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var canelButton: UIBarButtonItem!
    
    var delegate: AddItemViewControllerDelegate?
    var newItem: Bool = true
    
    var list: CKRecord!
    var item: CKRecord?
    
    @IBAction func numberDidChange(_ sender: UIStepper) {
        let number = Int(sender.value)
        numberLabel.text = "\(number)"
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: AnyObject) {
        let name = nameTextField.text
        let number = Int(numberStepper.value)
        
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        if item == nil {
            item = CKRecord(recordType: RecordTypeItems)
            let listReference = CKReference(recordID: list.recordID, action: .deleteSelf)
            item?.setObject(listReference, forKey: "list")
        }
        //double reference
        item?.setObject(name as! CKRecordValue, forKey: "name")
        item?.setObject(number as! CKRecordValue, forKey: "number")
        SVProgressHUD.show()
        publicDatabase.save(item!) {(record, error) in
            DispatchQueue.main.async (execute: {
                SVProgressHUD.dismiss()
                self.processResponse(record : record, error: error as? NSError)
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        newItem = item == nil
        let notificationCenter = NotificationCenter.default
        //notificationCenter.addObserver(self, selector: Selector(("textFieldTextDidChange:")), name: NSNotification.Name.UITextFieldTextDidChange, object: nameTextField)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupView() {
        updateNameTextField()
        updateNumberStepper()
        //updateSaveButton()
    }
    
    // MARK: -
    private func updateNameTextField() {
        if let name = item?.object(forKey: "name") as? String {
            nameTextField.text = name
        }
    }
    
    // MARK: -
//    private func updateSaveButton() {
//        let text = nameTextField.text
//
//        if let name = text {
//            saveButton.isEnabled = !name.isEmpty
//        } else {
//            saveButton.isEnabled = false
//        }
//    }
    private func processResponse(record: CKRecord?, error: NSError?) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "We were not able to save your item."
            
        } else if record == nil {
            message = "We were not able to save your item."
        }
        
        if !message.isEmpty {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            if newItem {
                delegate?.controller(controller: self, didAddItem: item!)
            } else {
                delegate?.controller(controller: self, didUpdateItem: item!)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateNumberStepper() {
        if let number = item?.object(forKey: "number") as? Double {
            numberStepper.value = number
        }
    }
    
//    func textFieldTextDidChange(notification: NSNotification) {
//        updateSaveButton()
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
