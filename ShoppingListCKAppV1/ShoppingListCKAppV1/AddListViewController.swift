//
//  AddListViewController.swift
//  ShoppingListCKAppV1
//
//  Created by Robert Wong on 9/27/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CloudKit
import SVProgressHUD

protocol AddListViewControllerDelegate {
    func controller(controller: AddListViewController, didAddList list: CKRecord)
    func controller(controller: AddListViewController, didUpdateList list: CKRecord)
}

class AddListViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var delegate: AddListViewControllerDelegate?
    var newList: Bool = true
    
    var list: CKRecord?
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        let name = nameTextField.text
        
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        if list == nil {
            list = CKRecord(recordType: RecordTypeLists)
        }
        
        list?.setObject(name as! CKRecordValue, forKey: "name")
        
        SVProgressHUD.show()
        
        publicDatabase.save(list!) { (record, error) in
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                self.processRecord(record: record, error: error as? NSError)
            })
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        newList = list == nil
        let notificationCenter = NotificationCenter.default
        //notificationCenter.addObserver(self, selector: "textFieldTextDidChange", name: NSNotification.Name.UITextViewTextDidChange, object: nameTextField)
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if (keyPath == "textFieldTextDidChange") {
//            let text = nameTextField.text
//                    print("Inside updateSaveButton")
//                    if let name = text {
//                        saveButton.isEnabled = !name.isEmpty
//                    } else {
//                        saveButton.isEnabled = false
//                    }
//        }
//    }

    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
    }
    
    private func processRecord(record: CKRecord?, error: NSError?) {
        var message = ""
        if let error = error {
            print(error)
            message = "We were not able to save your list"
        } else if record == nil {
            message = "We are not able to save your list"
        }
        
        if !message.isEmpty {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

            present(alertController, animated: true, completion: nil)
        } else {
            if newList {
                delegate?.controller(controller: self, didAddList: list!)
            } else {
                delegate?.controller(controller: self, didUpdateList: list!)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupView() {
        updateNameTextField()
        //updateSaveButton()
    }
    
    private func updateNameTextField() {
        if let name = list?.object(forKey: "name") as? String {
            nameTextField.text = name
        }
    }
    
//    private func updateSaveButton() {
//        let text = nameTextField.text
//        print("Inside updateSaveButton")
//        if let name = text {
//            saveButton.isEnabled = !name.isEmpty
//        } else {
//            saveButton.isEnabled = false
//        }
//    }
//
//    func textFieldTextDidChange(notification: NSNotification) {
//        print("Inside textFieldTextDidChange")
//        updateSaveButton()
//    }

}
