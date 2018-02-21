//
//  AddMemoryViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/12/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class AddMemoryViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var memoryNotes: UITextView!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var sectionName: UILabel!
    //@IBOutlet weak var sectionName: UITextField!
    
    var storedImage: UIImage?
    var imageURL: NSURL?
    var userData: UserData?

    override func viewDidLoad() {
        super.viewDidLoad()

        memoryNotes.delegate = self
        memoryNotes.text = "Add notes!"
        memoryNotes.textColor = UIColor.lightGray
        setupNavBarItems()
        viewImage.image = storedImage
        // Do any additional setup after loading the view.
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: sectionName.frame.size.height - width, width:  sectionName.frame.size.width, height: sectionName.frame.size.height)
        border.borderWidth = width
        sectionName.layer.addSublayer(border)
        sectionName.layer.masksToBounds = true
        
        let sectionLabelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        sectionName.isUserInteractionEnabled = true
        sectionName.addGestureRecognizer(sectionLabelTap)
        
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
        
        memoryNotes.resignFirstResponder()
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
        return true;
    }
    
    func setupNavBarItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem(image:UIImage(named:"icon_back"), style:.plain, target:self, action:#selector(AddMemoryViewController.buttonAction(_:)))
        //backButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButton
        
        let saveButton = UIBarButtonItem(image:UIImage(named:"icon_checkmark"), style:.plain, target:self, action:#selector(AddMemoryViewController.saveButtonAction(_:)))
        //backButton.tintColor = UIColor.whte
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if memoryNotes.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
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
        saveToDB()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemoryTable" {
             let memoryListVC = segue.destination as? ReturningUserCityDetailTableViewController
            memoryListVC?.userData = userData
        }
    }
    
    func saveToDB() {
        guard let sectionName = sectionName.text else {
            return
        }
        if sectionName == "" {
            AlertBox.sendAlert(boxMessage: "Section name cannot be empty", presentingController: self)
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
                self.performSegue(withIdentifier: "showMemoryTable", sender: self)
            })
        }
    }
    
    func updateFirebase(imageURL: String, city: String, userID: String, sectionName: String, timeStamp: String){
        let firebaseRef = Database.database()
        let imagePath = "\(userID)/\(city)/\(sectionName)/\(timeStamp)/\(imageURL)"
        let values = ["Image": imagePath, "Notes": memoryNotes.text] as [String : Any]
        let userReference = firebaseRef.reference().child("Users").child(userID).child("Cities").child(city).child(sectionName).child(timeStamp)
        userReference.updateChildValues(values)
    }
    
    func sendImage(imageURL: NSURL, city: String, userID: String, sectionName: String, timeStamp: String, completion: @escaping () -> () ) {
        let timeStampString = String(timeStamp)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let uploadSite = storageRef.child(userID).child(city).child(sectionName).child(timeStampString).child(imageURL.lastPathComponent!)
        let uploadTask = uploadSite.putFile(from: imageURL as URL)
        uploadTask.observe(.success) { snapshot in
            completion()
        }
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

extension AddMemoryViewController: SelectionStringDelegate {
    func setupSelectionString(selection: String) {
        sectionName.text = selection
    }
}
