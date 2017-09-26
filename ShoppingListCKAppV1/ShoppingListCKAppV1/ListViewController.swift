//
//  ViewController.swift
//  ShoppingListCKAppV1
//
//  Created by Robert Wong on 9/25/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CloudKit

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchUserRecordID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fetchUserRecordID() {
        let defaultContainer = CKContainer.default()
        
        defaultContainer.fetchUserRecordID(completionHandler: {(recordID, error) -> Void in
            if let responseError = error {
                print(responseError)
            } else if let userRecordID = recordID {
                DispatchQueue.main.async(execute: {
                    self.fetchUserRecord(recordID: userRecordID)
                })
            }
        })
    }
    
    private func fetchUserRecord(recordID: CKRecordID) {
        let defaultContainer = CKContainer.default()
        
        let privateDatabase = defaultContainer.privateCloudDatabase
        
        privateDatabase.fetch(withRecordID: recordID) { (record, error) in
            if let responseError = error {
                print(responseError)
            } else if let userRecord = record {
                print(userRecord)
            }
        }
    }
}





