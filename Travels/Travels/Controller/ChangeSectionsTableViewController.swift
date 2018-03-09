//
//  ChangeSectionsTableViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/31/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

protocol ChangeSectionNameDelegate {
    func changeSectionString(selection: String)
}

protocol ReplaceSectionNameDelegate {
    func replaceSectionString(newSection: String)
}

class ChangeSectionsTableViewController: UITableViewController {
    
    var userData: UserData?
    var sectionNameContainer: [String]?
    
    var changeSectionNameDelegate : ChangeSectionNameDelegate!
    var replaceSectionNameDelegate: ReplaceSectionNameDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        guard let userID = userData?.userID, let selectedCity = userData?.currentCitySelection else { return }
        setupSectionData(userID: userID, city: selectedCity)
        setupNavBarItems()
    }
    
    func setupNavBarItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(ChangeSectionsTableViewController.backAction(_:)))
        //backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backAction(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let returningToMemoriesVC = segue.destination as? ReturningUserCityDetailTableViewController {
//            returningToMemoriesVC.userData = userData
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSectionData(userID: String, city: String) {
        let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city)
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            var sectionContainer : [String] = []
            for city in snapshot.children {
                let snap = city as! DataSnapshot
                let key = snap.key
                sectionContainer.append(key)
            }
            self.sectionNameContainer = sectionContainer
            self.tableView.reloadData()
        })
    }
    
    func sectionChange() {
        guard let indexPath = self.tableView.indexPathForSelectedRow, let sectionNames = sectionNameContainer else { return }
        userData?.sectionName = sectionNames[indexPath.row]
        changeSectionNameDelegate.changeSectionString(selection: sectionNames[indexPath.row])
        navigationController?.popViewController(animated: true)
        //userData?.sectionName = sectionNameContainer?[indexPath.row]
        //changeSectionNameDelegate.changeSectionString(selection: sectionNameContainer?[indexPath.row])
        
        //performSegue(withIdentifier: "newSectionPicked", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sectionNameContainer = sectionNameContainer else { return 1 }
        return sectionNameContainer.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionName", for: indexPath)
        cell.textLabel?.text = sectionNameContainer?[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Goku", size: 33.9)
        cell.textLabel?.textAlignment = .center
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sectionChange()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            guard let sectionNames = self.sectionNameContainer, let userID = self.self.userData?.userID, let selectedCity = self.userData?.currentCitySelection else { return }
            let databaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(selectedCity).child(sectionNames[indexPath.row])
            if sectionNames.count == 1 {
                AlertBox.sendAlert(boxMessage: "Cannot delete the last section. Please delete the city in the city selection screen ", presentingController: self)
            } else {
                if self.userData?.sectionName == sectionNames[indexPath.row] {
                    self.replaceSectionNameDelegate.replaceSectionString(newSection: sectionNames[indexPath.row + 1])
                }
                databaseRef.removeValue()
                self.sectionNameContainer?.remove(at: indexPath.row)
                self.tableView?.deleteRows(at: [indexPath], with: .fade)
            }
        }
        delete.backgroundColor = .red
        
        return [delete]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
     Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
