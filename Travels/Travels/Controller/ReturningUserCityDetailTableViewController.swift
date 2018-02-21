//
//  ReturingUserCityDetailTableViewController.swift
//  
//
//  Created by Robert Wong on 1/16/18.
//

import UIKit
import Firebase
import GooglePlaces

class ReturningUserCityDetailTableViewController: UITableViewController {
    
    var userData: UserData?
    var userID: String?
    var selectedCity: String?
    var tableData = [[String:Any]]()
    var currentSectionString: String?
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var changeSections: UIButton!
    
    @IBAction func editTable(_ sender: UIButton) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            tableView.reloadData()
        }
        if !tableView.isEditing {
            
             guard let userID = userData?.userID, let selectedCity = userData?.currentCitySelection, let section = currentSectionString else { return }
            let deleteInfo = Database.database().reference().child("Users").child(userID).child("Cities").child(selectedCity).child(section)
            deleteInfo.removeValue()
            let count = tableData.count
            for idx in 0...count - 1 {
                let idxString = String(idx)
                let firebaseDB = Database.database().reference().child("Users").child(userID).child("Cities").child(selectedCity).child(section).child(idxString)
                let values = tableData[idx]
                firebaseDB.updateChildValues(values, withCompletionBlock: { ( err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                })
            }
        }
    }
    
//    @IBAction func backButton(_ sender: UIButton) {
//        //dismiss(animated: true, completion: nil)
//        let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeVC") as! ReturningUserCityTableViewController
//        homeVC.userData = userData
//        present(homeVC, animated: true, completion: nil)
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
        setupNavBarItems()
        
            tableView.estimatedRowHeight = 350
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.allowsSelectionDuringEditing = true
        guard let userID = userData?.userID, let selectedCity = userData?.currentCitySelection else { return }
        getSectionData(userID: userID, city: selectedCity, completion: {(sectionString) in
            self.setupTableView(userID: userID, city: selectedCity, section: sectionString) { (tableData) in
                DispatchQueue.main.async(execute:  {
                    self.cityName?.text = selectedCity
                    self.changeSections.setTitle(sectionString, for: .normal)
                    self.currentSectionString = sectionString
                    self.setupTableData(tableDataHolder: tableData)
                })
            }
        })
    }
    
    func setupNavBarItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(ReturningUserCityDetailTableViewController.backAction(_:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
        let addButton = UIBarButtonItem(image:UIImage(named:"icon_add_solo"), style:.plain, target:self, action:#selector(ReturningUserCityDetailTableViewController.addAction(_:)))
        addButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func backAction(_ sender: UIBarButtonItem) {
        //navigationController?.popViewController(animated: true)
        //navigationController?.popToRootViewController(animated: true)
        //navigationController?.popToViewController(ReturningUserCityTableViewController(), animated: true)
    }
    
    @objc func addAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addMemory", sender: self)
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
                indexData = [:]
                for (key, value) in v as! [String: Any] {
                    indexData[key] = value
                }
                indexDataArray.append(indexData)
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
            cell.notes.text = tableData[indexPath.row]["Notes"] as! String
            //cell.notes.delegate = self as! UITextViewDelegate
            cell.notes.tag = indexPath.row
            if tableView.isEditing {
                cell.notes.isEditable = true
            } else {
                cell.notes.isEditable = false
            }
            return cell
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("sadadasdasdassdSA")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableData[indexPath.row]["Notes"])
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let sectionItems = tableData[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let tempObj = self.tableData[fromIndexPath.row]
        tableData.remove(at: fromIndexPath.row)
        tableData.insert(tempObj, at: to.row)
    }

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
