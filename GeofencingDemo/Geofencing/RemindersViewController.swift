//
//  ViewController.swift
//  Geofencing
//
//  Created by Hesham Abd-Elmegid on 3/23/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class RemindersViewController: UITableViewController {
   
    var reminders = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RemindersManager.shared.updateLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reminders = RemindersManager.shared.reminders()
        tableView.reloadData()
    }
    
    // Mark: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCellIdentifier", for: indexPath)
        let reminder = reminders[indexPath.row]
        
        cell.textLabel?.text = reminder.text
        cell.detailTextLabel?.text = "\(reminder.coordinate.latitude), \(reminder.coordinate.longitude)"
        
        return cell
    }

    // Mark: - UITableViewDataDelegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            RemindersManager.shared.delete(reminderAtIndex: indexPath.row)
            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

