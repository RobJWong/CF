//
//  AddMemoryViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/12/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class AddMemoryViewController: UIViewController {
    
    @IBOutlet weak var imageText: UITextView!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var sectionName: UITextField!
    
    var storedImage: UIImage?
    var imageURL: NSURL?
    //var selectedCity: String?
    var userData: UserData?
    
    @IBAction func saveToDB(_ sender: UIButton) {
        print("selected City: ", userData?.currentCitySelection)
        print("image url string: ", imageURL)
        print("user id: ", userData?.userID)
        print("section name: ", sectionName.text)
        print("imageURLPath: ", imageURL?.lastPathComponent)
        guard let selectedCity = userData?.currentCitySelection, let imageURLString = imageURL, let userID = userData?.userID, let sectionName = sectionName.text, let imageURLPath = imageURL?.lastPathComponent else {
            //print("Something is null please check")
            return
        }
        let date = NSDate()
        let timeStamp = UInt64(floor(date.timeIntervalSince1970))
        let timeStampString = String(timeStamp)
        //checkDayChild(userID: userID, city: selectedCity)
        updateFirebase(imageURL: imageURLPath, city: selectedCity, userID: userID, sectionName: sectionName, timeStamp: timeStampString)
        sendImage(imageURL: imageURLString, city: selectedCity, userID: userID, sectionName: sectionName, timeStamp: timeStampString)
        performSegue(withIdentifier: "showMemoryTable", sender: self)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        viewImage.image = storedImage
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //let imagePath = "Users/" + userID + "/Cities/" + city + "/"
        let imagePath = "Users/\(userID)/Cities/\(city)/\(sectionName)/\(timeStamp)/\(imageURL)"
        print(imagePath)
        //let values = ["Image": imageURL.lastPathComponent, "Notes": imageText.text]
        let values = ["Image": imagePath, "Notes": imageText.text] as [String : Any]
        //print(imageText.text)
        let userReference = firebaseRef.reference().child("Users").child(userID).child("Cities").child(city).child(sectionName).child(timeStamp)
        userReference.updateChildValues(values)
    }
    
    func sendImage(imageURL: NSURL, city: String, userID: String, sectionName: String, timeStamp: String) {
        let timeStampString = String(timeStamp)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let uploadSite = storageRef.child(userID).child(city).child(sectionName).child(timeStampString).child(imageURL.lastPathComponent!)
        let uploadTask = uploadSite.putFile(from: imageURL as URL)
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
