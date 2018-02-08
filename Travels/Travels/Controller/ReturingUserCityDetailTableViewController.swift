//
//  ReturingUserCityDetailTableViewController.swift
//  
//
//  Created by Robert Wong on 1/16/18.
//

import UIKit
import Firebase
import GooglePlaces

class ReturingUserCityDetailTableViewController: UITableViewController {
    
    var userData: UserData?
    var userID: String?
    var selectedCity: String?
    var tableData = [[String:Any]]()
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var changeSections: UIButton!
    
    @IBAction func backButton(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeVC") as! ReturningUserCityTableViewController
        homeVC.userData = userData
        present(homeVC, animated: true, completion: nil)
    }
    
//    @IBAction func addMemory(_ sender: UIButton) {
//         performSegue(withIdentifier: "AddMemory", sender: self)
//    }
    
    @IBAction func switchSections(_ sender: UIButton) {
        let changeSectionVC = storyboard?.instantiateViewController(withIdentifier: "changeSection") as! ChangeSectionsTableViewController
        //changeSectionVC.selectionNameDelegate = self
        changeSectionVC.userData = userData
        present(changeSectionVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let backgroundImage = UIImage(named: "greenBG")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableViewAutomaticDimension
        guard let userID = userData?.userID, let selectedCity = userData?.currentCitySelection else { return }
        getSectionData(userID: userID, city: selectedCity, completion: {(sectionString) in
            self.setupTableView(userID: userID, city: selectedCity, section: sectionString) { (tableData) in
                DispatchQueue.main.async(execute:  {
                    self.cityName?.text = selectedCity
                    self.changeSections.setTitle(sectionString, for: .normal)
                    self.setupTableData(tableDataHolder: tableData)
                })
            }
        })
    }
    
    
    func setupTableView(userID: String, city: String, section: String, completion: @escaping ([[String:Any]]) -> () ) {
        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city).child(section)
        var indexData = [String:Any]()
        var indexDataArray = [[String:Any]]()
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for dataSet in snapshot.children {
                let snap = dataSet as! DataSnapshot
                let k = snap.key
                let v = snap.value
                //print("k snap:", k)
                //print("v snap:", v)
                indexData = [:]
                for (key, value) in v as! [String: Any] {
                    indexData[key] = value
                    //print("key: ", key)
                    //print("value: ", value)
                    //print("indexData[key]: ",[indexData[key]])
                }
                indexDataArray.append(indexData)
                //print("IDA: ", indexDataArray)
            }
            completion(indexDataArray)
        })
    }
    
    func getSectionData(userID: String, city:String, completion: @escaping(String) -> ()) {
        if userData?.sectionName != nil {
            guard let sectionName = userData?.sectionName else { return }
            completion(sectionName)
        } else {
            let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city)
            databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
                for idx in snapshot.children {
                    let snap = idx as! DataSnapshot
                    let key = snap.key
                    completion(key)
                    break
                }
            })
        }
    }
    
//    func getSectionData(userID: String, city: String, completion: @escaping (String) -> ()) {
//        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city)
//        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            //var sectionContainer : [String] = []
//            for city in snapshot.children {
//                let snap = city as! DataSnapshot
//                let key = snap.key
//                print("key: ", key)
//                completion(key)
//                break
//                //sectionContainer.append(key)
//            }
//        })
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addMemoryVC = segue.destination as? OnboardEmptyList {
            addMemoryVC.userData = userData
        }
    }
    
    func setupTableData(tableDataHolder: [[String:Any]]) {
        self.tableData = tableDataHolder
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let imageCheck = tableData[indexPath.row]["Image"] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageNotesData", for: indexPath) as! ImageNotesCell
            cell.notes.text = tableData[indexPath.row]["Notes"] as! String
            guard let imageFirebasePath = tableData[indexPath.row]["Image"] else {
                return cell }
            let pathReference = Storage.storage().reference(withPath: imageFirebasePath as! String)
            pathReference.getData(maxSize: 1 * 1614 * 1614) { data, error in
                if let error = error {
                    print(error)
                } else {
                    let image = UIImage(data: data!)
                    cell.storedImage.image = image
                }
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notesData", for: indexPath) as! NotesCell
            let noteString = tableData[indexPath.row]["Notes"] as! String
            print("NS: ",noteString)
            cell.notes.text = tableData[indexPath.row]["Notes"] as! String
            print("cell.notes: ",cell.notes)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableData[indexPath.row]["Notes"])
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

//extension ReturingUserCityDetailTableViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        tableView.beginUpdates()
//        tableView.endUpdates()
//    }
//}

