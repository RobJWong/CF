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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Generate names to store in database
        let firstNames = ["Jane", "John", "Stephen", "Stacy", "Taylor", "Alex", "Eren"]
        let lastNames = ["White", "Black", "Fox", "Jones", "King", "McQueen", "Yeager"]
        let ages = [25, 26, 20, 30, 27, 28, 23]
        let randomFirstName = firstNames[Int(arc4random_uniform(UInt32(firstNames.count)))]
        let randomLastName = lastNames[Int(arc4random_uniform(UInt32(lastNames.count)))]
        let randomAge = ages[Int(arc4random_uniform(UInt32(ages.count)))]
        
        // Get file manager needed to work with the file system
        let fileManager = FileManager.default
        var databaseUrl: URL? = nil
        
        do {
            let baseUrl = try
                fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            databaseUrl = baseUrl.appendingPathComponent("swifty.sqlite")
        } catch {
            print(error)
        }
        
        if let databaseUrl = databaseUrl {
            let fmdb = FMDatabase(path: databaseUrl.absoluteString)
            fmdb.open()
            
            let sqlStatement = "create table if not exists Person (ID Integer Primary key AutoIncrement, FirstName Text, LastName Text, Age Integer);"
            let insertStatement = "insert into Person (FirstName, LastName, Age) values ('\(randomFirstName)', '\(randomLastName)', \(randomAge));"
            do {
                try fmdb.executeUpdate(sqlStatement, values: nil)
                try fmdb.executeUpdate(insertStatement, values: nil)
            } catch {
                print(error)
            }
            
            let selectSql = "select * from Person"
            let fmdbResult = fmdb.executeQuery(selectSql, withParameterDictionary: nil)
            while (fmdbResult?.next())! {
                let rowId = fmdbResult?.int(forColumn: "ID")
                let firstName = fmdbResult?.string(forColumn: "FirstName")
                let lastName = fmdbResult?.string(forColumn: "LastName")
                let age = fmdbResult?.int(forColumn: "Age")
                
                print("Record ID: \(String(describing: rowId)) First Name: \(String(describing: firstName)) Last Name: \(String(describing: lastName)) Age: \(String(describing: age))")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

