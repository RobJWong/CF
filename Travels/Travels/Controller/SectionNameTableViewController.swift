//
//  SectionNameTableViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/25/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

protocol SelectionStringDelegate {
    func setupSelectionString(selection: String)
}

class SectionNameTableViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    var selectionNameDelegate : SelectionStringDelegate!
    var userData: UserData?
    var sectionNames: [String]?

    @IBAction func saveData(_ sender: UIButton) {
        savePressed(fromRow: false)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        let saveButton: UIButton = UIButton(type: UIButtonType.custom)
//        saveButton.setImage(UIImage(named: "icon_checkmark"), for: .normal)
//        saveButton.addTarget(self, action: Selector(("savePressed")), for: UIControlEvents.touchUpInside)
//        saveButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//        let barButton = UIBarButtonItem(customView: saveButton)
//        self.navigationItem.rightBarButtonItem = barButton
        
//        let border = CALayer()
//        let width = CGFloat(1)
//        //border.borderColor = UIColor.darkGray.cgColor
//        border.borderColor = UIColor.lightGray.cgColor
//        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
//
//        border.borderWidth = width
//        textField.layer.addSublayer(border)
//        textField.layer.masksToBounds = true
        guard let userID = userData?.userID, let city = userData?.currentCitySelection else { return }
        setupSavedData(userID: userID, city: city)
    }
    
    func setupTextbox() {
        let border = CALayer()
        let width = CGFloat(1)
        //border.borderColor = UIColor.darkGray.cgColor
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func savePressed(fromRow: Bool) {
        if fromRow == false {
            guard let stringInput = textField.text else { return }
            selectionNameDelegate.setupSelectionString(selection: stringInput)
            dismiss(animated: true , completion: nil)
        } else if fromRow == true {
            guard let indexPath = self.tableView.indexPathForSelectedRow, let sectionNames = sectionNames else { return }
            selectionNameDelegate.setupSelectionString(selection: sectionNames[indexPath.row])
            dismiss(animated: true , completion: nil)
        }
    }
    
    func setupSavedData(userID: String, city: String) {
        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city)
            databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
                var sectionContainer : [String] = []
                for city in snapshot.children {
                    let snap = city as! DataSnapshot
                    let key = snap.key
                    sectionContainer.append(key)
        }
            self.sectionNames = sectionContainer
            self.tableView.reloadData()
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
        guard let sectionNames = sectionNames else { return 1}
        return sectionNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionNames", for: indexPath)
        cell.textLabel?.text = sectionNames?[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Goku", size: 33.9)
        cell.textLabel?.textAlignment = .center
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        savePressed(fromRow: true)
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
