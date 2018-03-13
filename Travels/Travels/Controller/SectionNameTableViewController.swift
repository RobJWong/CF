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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width * 1.25, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
        setupNavBarItems()
        guard let userID = userData?.userID, let city = userData?.currentCitySelection else { return }
        setupSavedData(userID: userID, city: city)
    }
    
    
    func setupNavBarItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(SectionNameTableViewController.buttonAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(image:UIImage(named:"icon_checkmark"), style:.plain, target:self, action:#selector(SectionNameTableViewController.checkmarkAction(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkmarkAction(_ sender: UIBarButtonItem) {
        savePressed(fromRow: false)
    }
    
    func setupTextbox() {
        let border = CALayer()
        let width = CGFloat(1)
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
            navigationController?.popViewController(animated: true)
        } else if fromRow == true {
            guard let indexPath = self.tableView.indexPathForSelectedRow, let sectionNames = sectionNames else { return }
            selectionNameDelegate.setupSelectionString(selection: sectionNames[indexPath.row])
            navigationController?.popViewController(animated: true)
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
        guard let sectionNames = sectionNames else { return 1 }
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

}


