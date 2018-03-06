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
    //@IBOutlet weak var sectionName: UITextField!
    @IBOutlet weak var sectionName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBarItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sectionName.addBottomBorderWithColorNotes(color: UIColor.black, width: 1)
        notesSection.contentInset = UIEdgeInsetsMake(40, 40, 40, 40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notesSection.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemoryTable" {
            let memoryListVC = segue.destination as? ReturningUserCityDetailTableViewController
            memoryListVC?.userData = userData
        }
        
//        if segue.identifier == "newUser" {
//            userData?.newUser = false
//            let navVC = segue.destination as? UINavigationController
//            let rVC = navVC?.viewControllers.first as! ReturningUserCityTableViewController
//            rVC.userData = userData
//        }
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        let sectionNameVC = storyboard?.instantiateViewController(withIdentifier: "SectionName") as! SectionNameTableViewController
        sectionNameVC.selectionNameDelegate = self
        sectionNameVC.userData = userData
        self.navigationController?.pushViewController(sectionNameVC, animated: true)
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonAction(_ sender: UIBarButtonItem) {
        saveToDB()
    }
    
    func setupNavBarItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(AddNotesViewController.buttonAction(_:)))
        //backButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(image:UIImage(named:"icon_checkmark"), style:.plain, target:self, action:#selector(AddNotesViewController.saveButtonAction(_:)))
        //backButton.tintColor = UIColor.whte
        self.navigationItem.rightBarButtonItem = saveButton
        
        let sectionLabelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        sectionName.isUserInteractionEnabled = true
        sectionName.addGestureRecognizer(sectionLabelTap)
    }
    
    func updateFirebase(city: String, userID: String, sectionName: String, timeStamp: String, notes: String) {
        let firebaseRef = Database.database()
        let values = ["Notes": notes]
        let userReference = firebaseRef.reference().child("Users").child(userID).child("Cities").child(city).child(sectionName).child(timeStamp)
        userReference.updateChildValues(values)
    }
    
    func saveToDB() {
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
        self.performSegue(withIdentifier: "showMemoryTable", sender: self)
//        if userData?.newUser == true {
//            self.performSegue(withIdentifier: "newUser", sender: self)
//        } else {
//            self.performSegue(withIdentifier: "showMemoryTable", sender: self)
//        }
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

extension UIView {
    func addBottomBorderWithColorNotes(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        print(frame.size.width)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width * 1.25 + 8, height: width)
        //border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: (superview?.frame.size.width)!, height: width)
        self.layer.addSublayer(border)
    }
}

