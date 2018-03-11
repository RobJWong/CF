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
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memoryNotes.delegate = self
        memoryNotes.text = "Add notes!"
        memoryNotes.textColor = UIColor.lightGray
        viewImage.image = storedImage
        
        setupNavBarItems()
        //setupSectionBorder()
        sectionName.addBottomBorderWithColorMemory(color: UIColor.black, width: 1)
        
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
    
    //func setupSectionBorder() {
    //Do any additional setup after loading the view.
//        let border = CALayer()
//        let width = CGFloat(1)
//        //border.borderColor = UIColor.lightGray.cgColor
//        border.borderColor = UIColor.black.cgColor
//        print(sectionName.frame.size.width)
//        border.frame = CGRect(x: 0, y: sectionName.frame.size.height - width, width:  sectionName.frame.size.width * 1.8, height: sectionName.frame.size.height)
//        border.borderWidth = width
//        sectionName.layer.addSublayer(border)
//        sectionName.layer.masksToBounds = true
    //}
    
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
//        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 252.0 / 255.0, green: 242.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
        
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
        activityIndicator.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopAnimation() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(userData?.newUser)
        if segue.identifier == "newUser" {
            stopAnimation()
            let navVC = segue.destination as? UINavigationController
            let rVC = navVC?.viewControllers.first as! ReturningUserCityTableViewController
            rVC.userData = userData
        }
        if segue.identifier == "showMemoryTable" {
            stopAnimation()
            let memoryListVC = segue.destination as? ReturningUserCityDetailTableViewController
            memoryListVC?.userData = userData
        }
    }
    
//option 1.1
//    func saveToDB() {
//        guard let sectionName = sectionName.text else {
//            return
//        }
//        if sectionName == "Choose Category" {
//            AlertBox.sendAlert(boxMessage: "Please enter a section name", presentingController: self)
//            return
//        }
//        guard let selectedCity = userData?.currentCitySelection, let imageURLString = imageURL, let userID = userData?.userID, let imageURLPath = imageURL?.lastPathComponent else {
//            return
//        }
//        let date = NSDate()
//        let timeStamp = UInt64(floor(date.timeIntervalSince1970))
//        let timeStampString = String(timeStamp)
//
//        sendImage(imageURL: imageURLString, city: selectedCity, userID: userID, sectionName: sectionName, timeStamp: timeStampString) { () in
//            DispatchQueue.main.async(execute: {
//                self.userData?.sectionName = sectionName
//                if self.userData?.newUser == true {
//                    self.performSegue(withIdentifier: "newUser", sender: self)
//                } else {
//                    self.performSegue(withIdentifier: "showMemoryTable", sender: self)
//                }
//            })
//        }
//    }
//
//    func sendImage(imageURL: NSURL, city: String, userID: String, sectionName: String, timeStamp: String, completion: @escaping () -> () ) {
//        let uploadSite = Storage.storage().reference().child(userID).child(city).child(sectionName).child(timeStamp).child(imageURL.lastPathComponent!)
//        if let uploadData = UIImagePNGRepresentation(self.viewImage.image!) {
//        uploadSite.putData(uploadData, metadata: nil, completion: {(metadata, error) in
//            if error != nil {
//                print(error)
//                return
//            }
//            let imageLink = metadata?.downloadURL()?.absoluteString
//            let values = ["Image": imageLink, "Notes": self.memoryNotes.text] as [String: Any]
//            self.updateFirebaseDB(userID: userID, city: city, sectionName: sectionName, timeStamp: timeStamp, values: values)
//            completion()
//            })
//        }
//    }
//
//    func updateFirebaseDB(userID: String, city: String, sectionName: String, timeStamp: String, values: [String:Any]) {
//        let firebaseRef = Database.database().reference().child("Users").child(userID).child("Cities").child(city).child(sectionName).child(timeStamp)
//        firebaseRef.updateChildValues(values)
//    }
//}

//original
    func saveToDB() {
        guard let sectionName = sectionName.text else {
            return
        }
        if sectionName == "Choose Category" {
            AlertBox.sendAlert(boxMessage: "Please enter a section name", presentingController: self)
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
                ///this
                self.userData?.sectionName = sectionName
                //self.performSegue(withIdentifier: "showMemoryTable", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//}

extension AddMemoryViewController: SelectionStringDelegate {
    func setupSelectionString(selection: String) {
        sectionName.text = selection
    }
}

extension UIView {
    func addBottomBorderWithColorMemory(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        print(frame.width)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        //border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: (superview?.frame.size.width)!, height: width)
        self.layer.addSublayer(border)
    }
}
