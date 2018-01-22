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
    var userID: String?
    var selectedCity: String?
    var tableData = [[String:Any]]()
    //var sectionSelection = [String]()
    //var cityData: [CellData]?
    //////////have sectionSelection be a var type string of value of drop down selection
    //var sectionSelection = [String]()
    //var testContainer : [[String:Any]] = []
    //var testContainer = [[String:Any]]()

    @IBAction func addMemory(_ sender: UIBarButtonItem) {
         performSegue(withIdentifier: "AddMemory", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        guard let userID = userData?.userID, let selectedCity = userData?.currentCitySelection else { return }
        self.userID = userID
        self.selectedCity = selectedCity
        
        //Invoke after drop down selection has been changed
        //getSectionName(userID: userID, city: selectedCity)
        //setupSavedData(userID: userID, city: selectedCity)
        setupSavedData(userID: userID, city: selectedCity) { (tableData) in
            DispatchQueue.main.async(execute: {
                self.setupTableData(tableDataHolder: tableData)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addMemoryVC = segue.destination as? OnboardingEmptyList {
            addMemoryVC.userData = userData
        }
    }
    
    func setupTableData(tableDataHolder: [[String:Any]]) {
        self.tableData = tableDataHolder
        self.tableView.reloadData()
    }
    
    func setupSavedData(userID: String, city: String, completion: @escaping ([[String:Any]]) -> ()) {
        var indexData = [String:Any]()
        var indexDataArray = [[String:Any]]()
        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city).child("Wow")
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for dataSet in snapshot.children {
                let snap = dataSet as! DataSnapshot
                let k = snap.key
                let v = snap.value
                for (key, value) in v as! [String: Any] {
                    indexData[key] = value
                }
                indexDataArray.append(indexData)
            }
            completion(indexDataArray)
        })
    }
    
//    func getSectionName(userID: String, city: String) {
//        var temp = [String]()
//        let databaseFirebase = Database.database().reference().child("Users").child(userID).child("Cities").child(city)
//        databaseFirebase.observeSingleEvent(of: .value, with: { (snapshot ) in
//            for subChild in snapshot.children {
//                let snap = subChild as! DataSnapshot
//                print(snap.key)
//                temp.append(snap.key)
//            }
//            self.sectionSelection = temp
//            self.tableView.reloadData()
//        })
//    }
    
//    func setupSavedData(userID: String, city: String) {
//        var indexData = [String:Any]()
//        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city).child("Wow")
//        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            for dataSet in snapshot.children {
//                let snap = dataSet as! DataSnapshot
//                let k = snap.key
//                let v = snap.value
//                for (key, value) in v as! [String: Any] {
//                    indexData[key] = value
//                }
//                self.testContainer.append(indexData)
//            }
//            self.tableView.reloadData()
//        })
//    }
    
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
        //guard let tableDataTest = tableData else { return 1 }
        //print(tableCellData)
        //return tableCellData.count
        //print(tableCellData?.count)
        //return 1
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityData", for: indexPath) as! CityDetailTableViewCell
        cell.notes.text = tableData[indexPath.row]["Notes"] as! String
        guard let imageFirebasePath = tableData[indexPath.row]["Image"] else { return cell }
        let pathReference = Storage.storage().reference(withPath: imageFirebasePath as! String)
        
        pathReference.getData(maxSize: 1 * 1614 * 1614) { data, error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                cell.storedImage.image = image
            }
        }
        
//        pathReference.getData(maxSize: 1*1024*1024, completion: data, error in
//        if let error = error {
//            print(error)
//        } else {
//            let image = UIImage(data: data!)
//            cell.storedImage.image = image
//        })
        
//        let imageURL = Storage.storage().reference(forURL: imageURLString)
//        imageURL.downloadURL(completion: { (url, error) in
//            if error != nil {
//                print("Problem downloading image ", error?.localizedDescription)
//                return
//            }
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//
//                if error != nil {
//                    print(error)
//                    return
//                }
//
//                guard let imageData = UIImage(data: data!) else { return }
//
//                DispatchQueue.main.async {
//                    cell.storedImage.image = imageData
//                    cell.notes.text = self.tableData[indexPath.row]["Notes"] as! String
//                }
//
//            }).resume()
//        })
        //print(testContainer[0]["Image"])
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cityData", for: indexPath)
        //guard let tableCellData = tableCellData else { return cell }
        //guard let imageIncomplete = tableCellData[indexPath.row]["Image"], let notes = tableCellData[indexPath.row]["Notes"] else { return cell}
        //let storage = Storage.storage().reference().child(<#T##path: String##String#>)
        //let storage = Storage.storage().reference(forURL: "Users/0SNIwGemwHdcwjvHzBLqyKPBLdk2/Cities/Lisbon/dasdasdasdasdasfdsfds/1516439382/A06B87CB-1D8E-45B2-90FE-3165E59EB820.jpeg")
        //image string "Users/0SNIwGemwHdcwjvHzBLqyKPBLdk2/Cities/Lisbon/dasdasdasdasdasfdsfds/1516439382/A06B87CB-1D8E-45B2-90FE-3165E59EB820.jpeg"
        //let storageRef = storage.reference(forURL: imageIncomplete)
        //cell.notes.delegate = self
        //cell.notes.text = notes

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

extension ReturingUserCityDetailTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
