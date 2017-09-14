//
//  ViewController.swift
//  SQLiteAppV1
//
//  Created by Robert Wong on 9/13/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func saveInfoToDB(_ sender: UIButton) {
        let fileManager = FileManager.default
        var databaseUrl: URL? = nil
        
        do {
            let baseUrl = try
                fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            databaseUrl = baseUrl.appendingPathComponent("sqldemoapp.sqlite")
        } catch {
            print(error)
        }
        
        if let databaseUrl = databaseUrl {
            let fmdb = FMDatabase(path: databaseUrl.absoluteString)
            fmdb.open()
            
            let sqlStatement = "create table if not exists PersonInfo (ID Integer Primary key AutoIncrement, Username Text, Password Text);"
            
            let usernameFieldText = usernameField.text!
            let passwordFieldText = passwordField.text!
            let insertStatement = "insert into PersonInfo (Username, Password) values ('\(usernameFieldText)', '\(passwordFieldText)');"
            do {
                try fmdb.executeUpdate(sqlStatement, values: nil)
                try fmdb.executeUpdate(insertStatement, values: nil)
            } catch {
                print(error)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

}

