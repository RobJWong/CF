//
//  AddMemoryViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/12/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AddMemoryViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var memoryNotes: UITextView!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var rightCaretImage: UIImageView!
    
    var storedImage: UIImage?
    var imageURL: NSURL?
    var userData: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memoryNotes.delegate = self
        memoryNotes.text = "Add notes!"
        memoryNotes.textColor = UIColor.lightGray
        viewImage.image = storedImage
        sectionName.text = "Select Category"
        setupNavBarItems()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.dismissKeyboard(_:)))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        memoryNotes.inputAccessoryView = toolBar
        
        let sectionLabelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        sectionName.isUserInteractionEnabled = true
        sectionName.addGestureRecognizer(sectionLabelTap)
        
        let rightCaretTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        rightCaretImage.isUserInteractionEnabled = true
        rightCaretImage.addGestureRecognizer(rightCaretTap)
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapScreen)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add notes!"
            textView.textColor = UIColor.lightGray
            textView.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setupNavBarItems() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(AddMemoryViewController.buttonAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(image:UIImage(named:"icon_checkmark"), style:.plain, target:self, action:#selector(AddMemoryViewController.saveButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if memoryNotes.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height / 1.25
            }
        }
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
        if sectionName.text == "Select Category" {
            AlertBox.sendAlert(boxMessage: "Please enter a section name", presentingController: self)
            return
        } else {
            saveToDB()
            SVProgressHUD.show(withStatus: "Uploading memory")
            SVProgressHUD.setDefaultMaskType(.black)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newUser" {
            SVProgressHUD.dismiss()
            let navVC = segue.destination as? UINavigationController
            let rVC = navVC?.viewControllers.first as! ReturningUserCityTableViewController
            rVC.userData = userData
        }
        if segue.identifier == "showMemoryTable" {
            SVProgressHUD.dismiss()
            let memoryListVC = segue.destination as? ReturningUserCityDetailTableViewController
            memoryListVC?.userData = userData
        }
    }
    
    func saveToDB() {
        guard let sectionName = sectionName.text else {
            return
        }
        guard let selectedCity = userData?.currentCitySelection, let imageURLString = imageURL, let userID = userData?.userID, let imageURLPath = imageURL?.lastPathComponent else {
            return
        }
        let date = NSDate()
        let timeStamp = UInt64(floor(date.timeIntervalSince1970))
        let timeStampString = String(timeStamp)
        updateFirebase(imageURL: imageURLPath, city: selectedCity, userID: userID, sectionName: sectionName, timeStamp: timeStampString)
        sendImage(imageURL: imageURLString, city: selectedCity, userID: userID, sectionName: sectionName, timeStamp: timeStampString) { () in
            DispatchQueue.main.async(execute: {
                self.userData?.sectionName = sectionName
                self.memoryNotes.resignFirstResponder()
                if self.userData?.newUser == true {
                    self.performSegue(withIdentifier: "newUser", sender: self)
                } else {
                    self.performSegue(withIdentifier: "showMemoryTable", sender: self)
                }
            })
        }
    }
    
    func updateFirebase(imageURL: String, city: String, userID: String, sectionName: String, timeStamp: String){
        let firebaseRef = Database.database()
        let imagePath = "\(userID)/\(city)/\(sectionName)/\(timeStamp)/\(imageURL)"
        let values = ["Image": imagePath, "Notes": memoryNotes.text] as [String : Any]
        let userReference = firebaseRef.reference().child("Users").child(userID).child("Cities").child(city).child(sectionName).child(timeStamp)
        userReference.updateChildValues(values)
        print("updated DB")
    }
    
    func sendImage(imageURL: NSURL, city: String, userID: String, sectionName: String, timeStamp: String, completion: @escaping () -> () ) {
        let timeStampString = String(timeStamp)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let uploadSite = storageRef.child(userID).child(city).child(sectionName).child(timeStampString).child(imageURL.lastPathComponent!)
        let uploadTask = uploadSite.putFile(from: imageURL as URL)
        uploadTask.observe(.success) { snapshot in
            print("uploaded Image")
            completion()
        }
    }
}

extension AddMemoryViewController: SelectionStringDelegate {
    func setupSelectionString(selection: String) {
        sectionName.text = selection
        sectionName.textColor = UIColor.black
    }
}
