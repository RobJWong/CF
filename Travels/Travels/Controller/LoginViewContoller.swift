//
//  ViewController.swift
//  Travels
//
//  Created by Robert Wong on 1/9/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginViewContoller: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate{
    
    var userData = UserData()
    
    @IBAction func googleSignIn(_sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newUser" {
            let oVC = segue.destination as? OnboardCitySelect
            oVC?.userData = userData
        }
        if segue.identifier == "returningUser" {
            let rVC = segue.destination as? ReturningUserCityTableViewController
            print(userData.userID)
            rVC?.userData = userData
        }
        
//        if let onboardCitySelectVC = segue.destination as? OnboardCitySelect {
//            onboardCitySelectVC.userData = userData
//        }
//        if let returningUserSelectVC = segue.destination as? ReturningUserCityTableViewController {
//            returningUserSelectVC.userData = userData
//        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            AlertBox.sendAlert(boxMessage: "Error logging in with Google" , presentingController: self)
        }
        guard let idToken = user.authentication.idToken, let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                AlertBox.sendAlert(boxMessage: "Error logging in with Google Credenitals" , presentingController: self)
                return
            }
            guard let uid = user?.uid, let email = user?.email, let user = user else { return }
            let firebaseRef = Database.database()
            let values = ["Email": email]
            //let userReference = firebaseRef.reference(fromURL: "https://travels-3ef98.firebaseio.com/").child("Users").child(uid)
            let testData = Database.database().reference()
            print("TestData: ", testData)
            let userReference = firebaseRef.reference().child("Users").child(uid)
            firebaseRef.reference().observeSingleEvent(of: .value, with: { (snapshot) in
                let userDataString = "Users/" + uid
                if snapshot.hasChild(userDataString) {
                    //send to returning page
                    //UserData.sharedInstance.didLogin(user: user)
                    print("returning user")
                    self.userData.didLogin(user: user)
                    //toggle for returning user section
                    ///self.performSegue(withIdentifier: "returningUser", sender: self)
                    self.performSegue(withIdentifier: "returningUser", sender: self)
                }
                else {
                    userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            AlertBox.sendAlert(boxMessage: "Error updating Firebase DB" , presentingController: self)
                            return
                        }
                        //if let user = user {
                        //UserData.sharedInstance.didLogin(user: user)
                        self.userData.didLogin(user: user)
                        let changeRequest = user.createProfileChangeRequest()
                        self.performSegue(withIdentifier: "newUser", sender: self)
                        print("Created user profile")
                        //}
                    })
                }
            })
        })
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        if (error != nil ) {
            print(Error.self)
        }
    }


}

