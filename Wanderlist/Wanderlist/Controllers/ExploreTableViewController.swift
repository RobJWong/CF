//
//  ExploreTableViewController.swift
//  Bolts
//
//  Created by Robert Wong on 1/2/18.
//

import Firebase
import UIKit

class ExploreTableViewController: UITableViewController {
    
    var selectedCity : String?
    var presetData = [PrepopulateTestData3]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //self.tableView.sectionHeaderHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        setupSavedLocations() {(presetData) in
            DispatchQueue.main.async(execute: {
                self.testCompletion(presetLocations: presetData)
            })
        }
    }
    
    func testCompletion(presetLocations: [PrepopulateTestData3]) {
        self.presetData = presetLocations
        self.tableView.reloadData()
    }
    
    func setupSavedLocations(completion: @escaping ([PrepopulateTestData3]) -> ()) {
        var presetDataSet = [PrepopulateTestData3]()
        let firebaseRef = Database.database()
        guard let selectedCity = selectedCity else { return }
        firebaseRef.reference().child("Preset").child(selectedCity).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: NSObject] {
                for (key, value) in dictionary {
                    guard let address = value.value(forKey: "Address") as? String, let description = value.value(forKey: "Description") as? String, let imageLink = value.value(forKey: "Image") as? String, let name = value.value(forKey: "Name") as? String, let notes = value.value(forKey: "Notes") as? String else {
                        print("issue with data, please check")
                        return
                }
                    let dataSet = PrepopulateTestData3(address: address, description: description, imageLink: imageLink, name: name, notes: notes)
                    //print("This is the data set: ", dataSet)
                    //print("This is an attempt to extract address from dataSet: ", dataSet.address)
                    presetDataSet.append(dataSet)
                    //print("This is the appended presetDataSet: ", presetDataSet)
                    //print("is an attempt to get address from presetDataset: ", presetDataSet[0].address)
                    completion(presetDataSet)
                }
            }
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
        //print("Number of rows: ", presetData.count)
        return presetData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TestTableViewCell
        // Configure the cell...
//        cell.locationAdddress.text = presetData[indexPath.row].address
//        cell.locationDescription.text = presetData[indexPath.row].description
//        cell.locationImage.text = presetData[indexPath.row].imageLink
//        cell.locationName.text = presetData[indexPath.row].name
//        cell.locationNotes.text = presetData[indexPath.row].address
        //print(presetData[indexPath.row][0].address)
        //cell.locationName.text = presetData[indexPath.row]
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
