//
//  ReturningUserCityTableViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/16/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class ReturningUserCityTableViewController: UITableViewController {
    
    var userData : UserData?
    var cities: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSavedLocations()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCityDetail" {
            let returningUserCityDetailVC = segue.destination as? ReturingUserCityDetailTableViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                userData?.currentCitySelection = cities?[indexPath.row]
                returningUserCityDetailVC?.userData = userData
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSavedLocations() {
        guard let uid = userData?.userID else {
            print("uid is nil")
            return
        }
        let databaseRef = Database.database().reference().child("Users").child(uid).child("Cities")
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            var cityContainer : [String] = []
            for city in snapshot.children {
                let snap = city as! DataSnapshot
                let key = snap.key
                cityContainer.append(key)
            }
            self.cities = cityContainer
            self.tableView.reloadData()
        })
    }
    
//    func setupSavedLocations(completion: @escaping ([String], [String:String]) -> ()) {
//        guard let uid = userID else { return }
//        let databaseRef = Database.database().reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/").child("Users").child(uid).child("Cities")
//        var dataTest : [String] = []
//        var dataTestDic : [String:String] = [:]
//        //var cityDictionary: [String:String]()
//        databaseRef.observeSingleEvent(of: .value, with: {(snapshot) in
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                let key = snap.key
//                guard case let rawCityData as NSObject = snap.value else { return }
//                guard let value = rawCityData.value(forKey: "Status") else { return }
//                dataTest.append(key)
//                dataTestDic[key] = value as! String
//            }
//            completion(dataTest, dataTestDic)
//        })
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let cities = cities else { return 1 }
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cities?[indexPath.row]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
