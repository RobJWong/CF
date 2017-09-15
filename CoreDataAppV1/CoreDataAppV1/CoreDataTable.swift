//
//  ShowCoreDataViewTableViewController.swift
//  CoreDataAppV1
//
//  Created by Robert Wong on 9/15/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTable: UITableViewController {
    
    var userData = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let user = userData[indexPath.row]
        let usernameData = user.value(forKey: "username")
        let passwordData = user.value(forKey: "password")
        cell.textLabel?.text = "Username: \(usernameData!) Password: \(passwordData!)"
        
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            userData = results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
        
    }

}
