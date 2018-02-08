//
//  AddNotesViewController.swift
//  Travels
//
//  Created by Robert Wong on 2/1/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class AddNotesViewController: UIViewController {
    
    var userData: UserData?
    
    @IBOutlet weak var notesSection: UITextView!
    @IBOutlet weak var sectionName: UITextField!
    
    @IBAction func showSelectionVC(_ sender: UIButton) {
        let sectionNameVC = storyboard?.instantiateViewController(withIdentifier: "SectionName") as! SectionNameTableViewController
        sectionNameVC.selectionNameDelegate = self
        sectionNameVC.userData = userData
        present(sectionNameVC, animated: true, completion: nil)
    }
    
    @IBAction func saveToDB(_ sender: UIButton) {
        guard let sectionName = sectionName.text, let selectedCity = userData?.currentCitySelection, let userID = userData?.userID else { return }
        if sectionName == "" {
            AlertBox.sendAlert(boxMessage: "Section name cannot be empty", presentingController: self)
            return
        }
        guard let noteText = notesSection.text else {
            AlertBox.sendAlert(boxMessage: "Note section should not be empty", presentingController: self)
            return
        }
        let date = NSDate()
        let timeStamp = UInt64(floor(date.timeIntervalSince1970))
        let timeStampString = String(timeStamp)
        
        updateFirebase(city: selectedCity, userID: userID, sectionName: sectionName, timeStamp: timeStampString, notes: noteText)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notesSection.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func updateFirebase(city: String, userID: String, sectionName: String, timeStamp: String, notes: String) {
        let firebaseRef = Database.database()
        let values = ["Notes": notes]
        let userReference = firebaseRef.reference().child("Users").child(userID).child("Cities").child(city).child(sectionName).child(timeStamp)
        userReference.updateChildValues(values)
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

extension AddNotesViewController: SelectionStringDelegate {
    func setupSelectionString(selection: String) {
        sectionName.text = selection
    }
}
