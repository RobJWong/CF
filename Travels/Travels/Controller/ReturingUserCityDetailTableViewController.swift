//
//  ReturingUserCityDetailTableViewController.swift
//  
//
//  Created by Robert Wong on 1/16/18.
//

import UIKit
import Firebase

class ReturingUserCityDetailTableViewController: UITableViewController {
    
    var userData: UserData?
    //var cityData: [CellData]?
    var tableCellData : [[String:String]]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350
        setupSavedData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSavedData() {
        guard let uid = userData?.userID, let selectedCity = userData?.currentCitySelection else {
            AlertBox.sendAlert(boxMessage: "UID or selectedCity is nil", presentingController: self)
            return
        }
        var temp = [String:String]()
        var temp2 = [[String:String]]()
        let databaseRef = Database.database().reference().child("Users").child(uid).child("Cities").child(selectedCity).child("Day 1")
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for dataSet in snapshot.children {
                let snap = dataSet as! DataSnapshot
                let key = snap.key
                let value = snap.value
                temp[key] = value as! String
            }
            temp2.append(temp)
            self.tableCellData = temp2
            self.tableView.reloadData()
        })
    }
//           if let dictionary = snapshot.value as? [String: Any] {
//                for (key, value) in dictionary {
//                    temp[key] = value
//                }
//            self.tableCellData?.append(temp)
//            self.tableView.reloadData()
//            }
//        })
//                    guard let imageURL = value.value(forKey: "Image"), let imageNotes = value.value(forKey: "Notes") else { return }
//                    let dataSet = ["ImageURL":imageURL, "Notes": imageNotes]
//                    self.cellData?.append(dataSet)
//                    self.tableView.reloadData()
//            guard let imageString = snapshot.childSnapshot(forPath: "Image").value, let imageNotes = snapshot.childSnapshot(forPath: "Notes").value else { return }
//            temp.append(["Image": imageString, "Notes":imageNotes])
//            //let storedCityData = ["Image": imageString, "Notes":imageNotes]
//            self.tableCellData = temp
//            self.tableView.reloadData()
//        })
            //var dataSet : [String: Any] = [:]
            //print("snapshot data: ",snapshot.childSnapshot(forPath:"Image"))
            //    for data in snapshot.children {
            //        let snap = data as! DataSnapshot
            //        let key = snap.key
            //        let value = snap.value
                    //print("Key: ", key)
                    //print("Value: ", value)
                    //let storedValue = CityDataCell(imageURL: <#T##String#>, imageText: <#T##String#>)
                    //cityData.append(storedValue)
            //    }
            //self.cellData = cityData
            //self.tableView.reloadData()
            //})

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let tableCellData = tableCellData else { return 1 }
        //print(tableCellData)
        //return tableCellData.count
        //print(tableCellData?.count)
        return tableCellData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cityData", for: indexPath) as! CityDetailTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityData", for: indexPath)
        guard let tableCellData = tableCellData else { return cell }
        guard let image = tableCellData[indexPath.row]["Image"], let notes = tableCellData[indexPath.row]["Notes"] else { return cell}
        cell.textLabel?.text = notes
        //print(tableCellData[indexPath.row]["Image"])
        //print(tableCellData[indexPath.row]["Notes"])
        //guard let tableCellData = tableCellData![indexPath.row] else { return cell }
        //print(tableCellData["Image"])
        //let cellData = tableCellData![indexPath.row]
        //cell.imageText.text = cellData["Notes"] as! String
//        guard let uid = userData?.userID, let selectedCity = userData?.currentCitySelection, let dataCell = cellData[indexPath.row] else {
//            AlertBox.sendAlert(boxMessage: "UID, selectedCity or cellData is nil", presentingController: self)
//            return cell
//        }
        //let imageRef = Database.database().reference().child("Users").child(uid).child("Cities").child(selectedCity).child("Day 1")
        //cell.imageText = dataCell.values("ImageNotes")
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
