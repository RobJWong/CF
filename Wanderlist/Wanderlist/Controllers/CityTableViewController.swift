//
//  CityTableViewController.swift
//  Wanderlist
//
//  Created by Robert Wong on 12/11/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class CityTableViewController: UITableViewController {
    
    //var userSettings = [User]()
    var cities: [String] = ["New York City", "San Francisco", "Montreal" , "Paris", "Lisbon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Goku", size: 33.9)
        cell.textLabel?.textAlignment = .center
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CityPlanning" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedCity = cities[indexPath.row]
                let controller = segue.destination as! CityDetailViewController
                //let uid = Auth.auth().currentUser?.uid
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let ref = Database.database().reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/")
                let userReference = ref.child("Users").child(uid).child("Cities").child(selectedCity)
                let values = ["Status": "Empty"]
                userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                })
                controller.citySelect = selectedCity
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if (segue.identifier == "CityPlanning") {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let selectedCity = cities[indexPath.row]
//                let controller = segue.destination as! CityDetailViewController
//                controller.citySelect = selectedCity
//
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let context = appDelegate.persistentContainer.viewContext
//                let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
//
//                let userData = User(entity: entity!, insertInto: context)
//                userData.returningUser = true
//                appDelegate.saveContext()
//                userSettings.append(userData)
//            }
//        }
//    }

}
