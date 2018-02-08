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
    //@IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var sectionName: UITextField!
    
    var storedImage: UIImage?
    var imageURL: NSURL?
    var userData: UserData?
    
    @IBAction func saveToDB(_ sender: UIButton) {
        guard let sectionName = sectionName.text else {
            return
        }
        if sectionName == "" {
            AlertBox.sendAlert(boxMessage: "Section name cannot be empty", presentingController: self)
            return
        }
        guard let selectedCity = userData?.currentCitySelection, let imageURLString = imageURL, let userID = userData?.userID, let imageURLPath = imageURL?.lastPathComponent else {
            //print("Something is null please    check")
            return
        }
        let date = NSDate()
        let timeStamp = UInt64(floor(date.timeIntervalSince1970))
        let timeStampString = String(timeStamp)
        //checkDayChild(userID: userID, city: selectedCity)
        updateFirebase(imageURL: imageURLPath, city: selectedCity, userID: userID, sectionName: sectionName, timeStamp: timeStampString)
        sendImage(imageURL: imageURLString, city: selectedCity, userID: userID, sectionName: sectionName, timeStamp: timeStampString) { () in
            DispatchQueue.main.async(execute: {
                self.userData?.sectionName = sectionName
                self.performSegue(withIdentifier: "showMemoryTable", sender: self)
            })
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showSelectionVC(_ sender: UIButton) {
        let sectionNameVC = storyboard?.instantiateViewController(withIdentifier: "SectionName") as! SectionNameTableViewController
        sectionNameVC.selectionNameDelegate = self
        sectionNameVC.userData = userData
        present(sectionNameVC, animated: true, completion: nil)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        memoryNotes.delegate = self
        memoryNotes.text = "Add notes!"
        memoryNotes.textColor = UIColor.lightGray
        //memoryNotes.becomeFirstResponder()
        
        viewImage.image = storedImage
        // Do any additional setup after loading the view.
//        let border = CALayer()
//        let width = CGFloat(1)
//        border.borderColor = UIColor.lightGray.cgColor
//        border.frame = CGRect(x: 0, y: sectionName.frame.size.height - width, width:  sectionName.frame.size.width, height: sectionName.frame.size.height)
//        border.borderWidth = width
//        sectionName.layer.addSublayer(border)
//        sectionName.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add notes!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    //THIS GETS ME THE DAY
//    func checkDayChild(userID: String, city: String) {
//        let databaseFirebase = Database.database().reference().child("Users").child(userID).child("Cities").child(city)
//        databaseFirebase.observeSingleEvent(of: .value, with: { (snapshot) in
//            for subChild in snapshot.children {
//                let snap = subChild as! DataSnapshot
//                print("Key: ", snap.key)
//            }
//        })
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemoryTable" {
             let memoryListVC = segue.destination as? ReturingUserCityDetailTableViewController
            memoryListVC?.userData = userData
        }
    }
    
    func updateFirebase(imageURL: String, city: String, userID: String, sectionName: String, timeStamp: String){
        let firebaseRef = Database.database()
        let imagePath = "\(userID)/\(city)/\(sectionName)/\(timeStamp)/\(imageURL)"
        //let imagePath = "\(userID)/\(city)/\("Wow")/\(timeStamp)/\(imageURL)"
        //print(imagePath)
        //let values = ["Image": imageURL.lastPathComponent, "Notes": imageText.text]
        let values = ["Image": imagePath, "Notes": memoryNotes.text] as [String : Any]
        //print(imageText.text)
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
