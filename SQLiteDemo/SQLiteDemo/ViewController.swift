//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by Robert Wong on 9/12/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        var sqliteDatabase: OpaquePointer? = nil
        var databaseUrl: URL? = nil
        
        do {
            let baseUrl = try
                fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            databaseUrl = baseUrl.appendingPathComponent("swift.sqlite")
        } catch {
            print(error)
        }
        
        if let databaseUrl = databaseUrl {
            let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
            let status = sqlite3_open_v2(databaseUrl.absoluteString.cString(using: String.Encoding.utf8)!, &sqliteDatabase, flags, nil)
            
            // Create SQLite table if it doesn't exist
            if status == SQLITE_OK {
                let errorMsg: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>! = nil
                let sqlStatement = "create table if not exists Person (ID Integer Primary key AutoIncrement, FirstName Text, LastName Text, Age Integer);"
                if sqlite3_exec(sqliteDatabase, sqlStatement, nil, nil, errorMsg) == SQLITE_OK {
                    print("Table was created")
                } else {
                    print("Failed to create table")
                }
                
                // Insert data into table row
                var statement: OpaquePointer? = nil
                let insertStatement = "insert into Person (FirstName, LastName, Age) values ('\(randomFirstName)', '\(randomLastName)', \(randomAge));"
                sqlite3_prepare_v2(sqliteDatabase, insertStatement, -1, &statement, nil)
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Row inserted")
                } else {
                    print("Row not inserted")
                }
                sqlite3_finalize(statement)
                
                // Read data from SQLite database
                var selectStatement: OpaquePointer? = nil
                let selectSql = "select * from Person"
                if sqlite3_prepare_v2(sqliteDatabase, selectSql, -1, &selectStatement, nil) == SQLITE_OK {
                    while sqlite3_step(selectStatement) == SQLITE_ROW {
                        let rowId = sqlite3_column_int(selectStatement, 0)
                        let first_name = sqlite3_column_text(selectStatement, 1)
                        let last_name = sqlite3_column_text(selectStatement, 2)
                        let age = sqlite3_column_int(selectStatement, 3)
                        
                        let fNameString = String(cString: first_name!)
                        let lNameString = String(cString: last_name!)
                        
                        print("Record ID: \(rowId) First Name: \(fNameString) Last Name: \(lNameString) Age: \(age)")
                    }
                }
                sqlite3_finalize(selectStatement)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

