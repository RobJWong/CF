//
//  FeedbackTableViewController.swift
//  Travels
//
//  Created by Robert Wong on 3/13/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class FeedbackTableViewController: UITableViewController, UITextViewDelegate {
    
    var userData: UserData?
    var feedbackMessage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelectionDuringEditing = true
        
        setupNavBarItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        view.endEditing(true)
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBarItems() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 252.0 / 255.0, green: 244.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(FeedbackTableViewController.buttonAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(image:UIImage(named:"icon_checkmark"), style:.plain, target:self, action:#selector(FeedbackTableViewController.saveButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapScreen)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        feedbackMessage = textView.text
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func saveButtonAction(_ sender: UIBarButtonItem) {
        if feedbackMessage == nil {
            AlertBox.sendAlert(boxMessage: "There is no message in the box.", presentingController: self)
            return
        } else {
            let date = NSDate()
            let timeStamp = UInt64(floor(date.timeIntervalSince1970))
            let timeStampString = String(timeStamp)

            guard let userEmail = userData?.email else { return }

            let firebaseRef = Database.database()
            let values = ["Feedback": feedbackMessage, "Email": userEmail]
            let userReference = firebaseRef.reference().child("Feedback").child(timeStampString)
            userReference.updateChildValues(values)
            navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotesCell
        cell.notes.delegate = self
        cell.notes.tag = indexPath.row
        // Configure the cell...
        return cell
    }

}
