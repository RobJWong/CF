//
//  ShowDataViewController.swift
//  SQLiteAppV1
//
//  Created by Robert Wong on 9/14/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ShowDataViewController: UIViewController {

    @IBOutlet weak var showSQLData: UITextView!
    var dataText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            let selectSql = "select * from PersonInfo"
            let fmdbResult = fmdb.executeQuery(selectSql, withParameterDictionary: nil)
            while (fmdbResult?.next())! {
                let rowId = fmdbResult?.int(forColumn: "ID")
                let username = fmdbResult?.string(forColumn: "Username")
                let password = fmdbResult?.string(forColumn: "Password")
                let rowData = "ID: \(rowId!) Username: \(username!), Password: \(password!)\n"
                dataText += rowData
            }
        }
        showSQLData.text = dataText
    }
    
    
}
