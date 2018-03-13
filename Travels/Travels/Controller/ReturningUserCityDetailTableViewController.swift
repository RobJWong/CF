//
//  ReturingUserCityDetailTableViewController.swift
//  
//
//  Created by Robert Wong on 1/16/18.
//

import UIKit
import Firebase
import GooglePlaces

class ReturningUserCityDetailTableViewController: UITableViewController, UITextViewDelegate {
    
    var userData: UserData?
    var userID: String?
    var selectedCity: String?
    var tableData = [[String:Any]]()
    var currentSectionString: String?
    var indexPathForEdit: Int?
    var endEditing: Bool?
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var changeSections: UIButton!
    
    @IBAction func switchSections(_ sender: UIButton) {
        self.performSegue(withIdentifier: "changeSectionName", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavBarItems()
        
        if userData?.newUser == true {
            userData?.newUser = false
            setupNavStack()
        }
        
        if userData?.addedNewItem == true {
            userData?.addedNewItem = false
            fixNavStack()
        }
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapScreen)
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelectionDuringEditing = true
        
        guard let userID = userData?.userID, let selectedCity = userData?.currentCitySelection else { return }
        getSectionData(userID: userID, city: selectedCity, completion: {(sectionString) in
            self.setupTableCellView(userID: userID, city: selectedCity, section: sectionString) { (tableData) in
                DispatchQueue.main.async(execute:  {
                    self.cityName?.text = selectedCity
                    self.changeSections.setTitle(sectionString, for: .normal)
                    self.currentSectionString = sectionString
                    self.setupTableData(tableDataHolder: tableData)
                })
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        saveAction()
    }
    
    func fixNavStack() {
        var stackArray = navigationController?.viewControllers ?? [Any]()
        //print(stackArray)
        stackArray.remove(at: 2)
        stackArray.remove(at: 3)
        //print(stackArray)
        navigationController?.viewControllers = (stackArray as? [UIViewController])!
    }
    
    func setupNavStack() {
        //let stack = self.navigationController?.viewControllers
    }
    
    func setupTableView() {
        cityName.adjustsFontSizeToFitWidth = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func setupNavBarItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 232.0 / 255.0, green: 243.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(ReturningUserCityDetailTableViewController.backAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        let addButton = UIBarButtonItem(image:UIImage(named:"icon_add_solo"), style:.plain, target:self, action:#selector(ReturningUserCityDetailTableViewController.addAction(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        saveAction()
    }
    
    @objc func backAction(_ sender: UIBarButtonItem) {
        userData?.sectionName = nil
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func addAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addMemory", sender: self)
    }
    
    func saveAction() {
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
                    print("Error updating: ", err)
                    return
                }
            })
        }
    }
    
    func setupTableCellView(userID: String, city: String, section: String, completion: @escaping ([[String:Any]]) -> () ) {
        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city).child(section)
        var indexData = [String:Any]()
        var indexDataArray = [[String:Any]]()
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for dataSet in snapshot.children {
                let snap = dataSet as! DataSnapshot
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
        if let changeSectionNameVC = segue.destination as? ChangeSectionsTableViewController {
            changeSectionNameVC.changeSectionNameDelegate = self
            changeSectionNameVC.userData = userData
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
        if tableData[indexPath.row]["Image"] != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageNotesData", for: indexPath) as! ImageNotesCell
            cell.notes.delegate = self
            cell.notes.tag = indexPath.row
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
            cell.notes.text = tableData[indexPath.row]["Notes"] as! String
            cell.notes.delegate = self
            cell.notes.tag = indexPath.row
            return cell
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let indexPath = textView.tag
        tableData[indexPath]["Notes"] = textView.text
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellCheck = tableView.cellForRow(at: indexPath)
        print("dasdadas")
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }

        if cellCheck is ImageNotesCell {
                indexPathForEdit = indexPath.row
        } else if cellCheck is NotesCell {
                indexPathForEdit = indexPath.row
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            self.tableData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveAction()
        }
        delete.backgroundColor = .red

        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let tempObj = self.tableData[fromIndexPath.row]
        tableData.remove(at: fromIndexPath.row)
        tableData.insert(tempObj, at: to.row)
    }
}

extension ReturningUserCityDetailTableViewController: ChangeSectionNameDelegate {
    func changeSectionString(selection: String) {
        changeSections.titleLabel?.text = selection
        userData?.sectionName = selection
    }
}

extension ReturningUserCityDetailTableViewController: ReplaceSectionNameDelegate {
    func replaceSectionString(newSection: String) {
        userData?.sectionName = newSection
    }
}
