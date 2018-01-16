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
    
    var storedImage: UIImage?
    var imageURL: NSURL?
    //var selectedCity: String?
    var userData: UserData?
    
    @IBAction func saveToDB(_ sender: UIButton) {
        //print("imageURL: ",imageURL!)
        //print("city: ", userData?.currentCitySelection)
//        print("city: ", userData?.currentCitySelection)
//        print("imageURL: ", imageURL)
//        print("userID: ", userData?.userID)
//        print("email: ", userData?.email)
        guard let selectedCity = userData?.currentCitySelection, let imageURLString = imageURL, let userID = userData?.userID else {
            print("Something is null please check")
            return
        }
        updateFirebase(imageURL: imageURLString, city: selectedCity, userID: userID)
        sendImage(imageURL: imageURLString, city: selectedCity, userID: userID)
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
    
    func updateFirebase(imageURL: NSURL, city: String, userID: String) {
        let firebaseRef = Database.database()
        let values = ["Image": imageURL.lastPathComponent, "Notes": imageText.text]
        let userReference = firebaseRef.reference().child("Users").child(userID).child(city).child("Day 1")
        userReference.updateChildValues(values)
    }
    
    func sendImage(imageURL: NSURL, city: String, userID: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let uploadSite = storageRef.child(userID).child(city).child("Day 1").child("1").child(imageURL.lastPathComponent!)
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
