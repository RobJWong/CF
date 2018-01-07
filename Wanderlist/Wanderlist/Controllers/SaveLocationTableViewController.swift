//
//  SaveLocationTableViewController.swift
//  Wanderlist
//
//  Created by Robert Wong on 12/27/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class SaveLocationTableViewController: UITableViewController {
    
    var userID: String?
    var savedLocationsDict: [String:String] = [:]
    var savedLocations: [String] = []
    var cityName: String?
    var statusFlag : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupSavedLocations() { (savedData, savedLocationsDic) in
            DispatchQueue.main.async(execute: {
                self.testCompletion(locations: savedData, cityStatus: savedLocationsDic)
            })
        }
    }
    
    func testCompletion(locations:[String], cityStatus: [String:String] ) {
        //print("Show updated locations: \(locations)")
        self.savedLocations = locations
        self.savedLocationsDict = cityStatus
        print(savedLocations)
        print(savedLocationsDict)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CityDetailViewController {
            print("Status Flag: ", statusFlag, "City Name: ", cityName)
            let cityDetailVCS = segue.destination as? CityDetailViewController
            cityDetailVCS?.citySelect = cityName
        }
        if segue.destination is SavedInCityTableViewController {
            print("Potation")
        }
    }
    
    //        if segue.destination is SaveLocationTableViewController {
    //            let saveLocationTVC = segue.destination as? SaveLocationTableViewController
    //            saveLocationTVC?.userID = userID
    //        }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cityName = savedLocations[indexPath.row]
        print(cityName)
        self.statusFlag = savedLocationsDict[cityName!]
        print(statusFlag)
        if statusFlag == "Empty" {
            performSegue(withIdentifier: "empty", sender: nil)
        }
        else {
            performSegue(withIdentifier: "notEmpty", sender: nil)
        }
        
    }
    
    func setupSavedLocations(completion: @escaping ([String], [String:String]) -> ()) {
        guard let uid = userID else { return }
        let databaseRef = Database.database().reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/").child("Users").child(uid).child("Cities")
        var dataTest : [String] = []
        var dataTestDic : [String:String] = [:]
        //var cityDictionary: [String:String]()
        databaseRef.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                guard case let rawCityData as NSObject = snap.value else { return }
                guard let value = rawCityData.value(forKey: "Status") else { return }
                dataTest.append(key)
                dataTestDic[key] = value as! String
            }
            completion(dataTest, dataTestDic)
        })
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
        return savedLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCities", for: indexPath)
        cell.textLabel?.text = savedLocations[indexPath.row]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
