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
    var sectionName: String?
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var changeSections: UIButton!
    
    @IBAction func backButton(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeVC") as! ReturningUserCityTableViewController
        homeVC.userData = userData
        present(homeVC, animated: true, completion: nil)
    }
    
//    @IBAction func addMemory(_ sender: UIBarButtonItem) {
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
        
//        let yourBackImage = UIImage(named: "icon_back")
//        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
//        //        self.navigationItem.backBarButtonItem?.title = ""
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        guard let userID = userData?.userID, let selectedCity = userData?.currentCitySelection else { return }
        if userData?.sectionName != nil {
            sectionName = userData?.sectionName
        } else {
            getSectionData(userID: userID, city: selectedCity) { (sectionString) in
                //DispatchQueue.main.async(execute: {
                self.sectionName = sectionString
                self.setupTableView(userID: userID, city: selectedCity, section: sectionString) { (tableData) in
                    DispatchQueue.main.async(execute:{
                        self.cityName?.text = selectedCity
                        self.changeSections.setTitle(self.sectionName, for: .normal)
                        self.setupTableData(tableDataHolder: tableData)
                    })
                }
                //})
            }
            //guard let selectedSection = sectionNameContainer?[0] else { return }
            //self.selectedSection = selectedSection
        }
//        setupSavedData(userID: userID, city: selectedCity) { (tableData) in
//            DispatchQueue.main.async(execute: {
//                self.setupButtonText()
//                self.setupTableData(tableDataHolder: tableData)
//            })
//        }
        //self.userID = userID
        //self.selectedCity = selectedCity
//        cityName?.text = selectedCity
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
                for (key, value) in v as! [String: Any] {
                    indexData[key] = value
                }
                indexDataArray.append(indexData)
            }
            completion(indexDataArray)
        })
    }
    
    //    func setupSavedData(userID: String, city: String, completion: @escaping ([[String:Any]]) -> ()) {
    //        var indexData = [String:Any]()
    //        var indexDataArray = [[String:Any]]()
    //        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city).child("Spring falls")
    //        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
    //            for dataSet in snapshot.children {
    //                let snap = dataSet as! DataSnapshot
    //                let k = snap.key
    //                let v = snap.value
    //                for (key, value) in v as! [String: Any] {
    //                    indexData[key] = value
    //                }
    //                indexDataArray.append(indexData)
    //            }
    //            completion(indexDataArray)
    //        })
    //    }
    
    func getSectionData(userID: String, city: String, completion: @escaping (String) -> ()) {
        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city)
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //var sectionContainer : [String] = []
            for city in snapshot.children {
                let snap = city as! DataSnapshot
                let key = snap.key
                completion(key)
                //sectionContainer.append(key)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addMemoryVC = segue.destination as? OnboardEmptyList {
            addMemoryVC.userData = userData
        }
    }
    
//    func setupButtonText() {
//        if userData?.sectionName == nil {
//            print("section name nil")
//            //print(sectionNameContainer![0])
//            changeSections.setTitle(sectionNameContainer![0], for: .normal)
//            selectedSection = sectionNameContainer![0]
//
//        } else {
//            print("something else")
//            changeSections.setTitle(userData?.sectionName, for: .normal)
//            selectedSection = userData?.sectionName
//        }
//    }
    
//    func getSectionData(userID: String, city: String, completion: @escaping ( )) {
//        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city)
//        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            var sectionContainer : [String] = []
//            for city in snapshot.children {
//                let snap = city as! DataSnapshot
//                let key = snap.key
//                sectionContainer.append(key)
//            }
//            self.sectionNameContainer = sectionContainer
//        })
//    }
    
    func setupTableData(tableDataHolder: [[String:Any]]) {
        self.tableData = tableDataHolder
        self.tableView.reloadData()
    }
    
//    func setupSavedData(userID: String, city: String, completion: @escaping ([[String:Any]]) -> ()) {
//        var indexData = [String:Any]()
//        var indexDataArray = [[String:Any]]()
//        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city).child("Spring falls")
//        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            for dataSet in snapshot.children {
//                let snap = dataSet as! DataSnapshot
//                let k = snap.key
//                let v = snap.value
//                for (key, value) in v as! [String: Any] {
//                    indexData[key] = value
//                }
//                indexDataArray.append(indexData)
//            }
//            completion(indexDataArray)
//        })
//    }

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

//extension ReturingUserCityDetailTableViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        tableView.beginUpdates()
//        tableView.endUpdates()
//    }
//}

