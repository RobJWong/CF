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
    
    @IBOutlet weak var googleLoginView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("test2")
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        let googleLogin = UITapGestureRecognizer(target: self, action: #selector(googleLoginTapped(_:)))
        googleLoginView.isUserInteractionEnabled = true
        googleLoginView.addGestureRecognizer(googleLogin)
    }
    
    @objc func googleLoginTapped(_ sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newUser" {
//            let oVC = segue.destination as? OnboardCitySelect
//            oVC?.userData = userData
            let navVC = segue.destination as? UINavigationController
            let oVC = navVC?.viewControllers.first as! OnboardCitySelect
            oVC.userData = userData
        }
        if segue.identifier == "returningUser" {
            let navVC = segue.destination as? UINavigationController
            let rVC = navVC?.viewControllers.first as! ReturningUserCityTableViewController
            rVC.userData = userData
//            let rVC = segue.destination as? ReturningUserCityTableViewController
//            print(userData.userID)
//            rVC?.userData = userData
        
        }
        
//        if let onboardCitySelectVC = segue.destination as? OnboardCitySelect {
//            onboardCitySelectVC.userData = userData
//        }
//        if let returningUserSelectVC = segue.destination as? ReturningUserCityTableViewController {
//            returningUserSelectVC.userData = userData
//        }
    }
    
    func offlineFunctionOnly() {
        self.performSegue(withIdentifier: "returningUser", sender: self)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Error signing in: ", err)
            //AlertBox.sendAlert(boxMessage: "Error logging in with Google" , presentingController: self)
            return
        }
        guard let idToken = user.authentication.idToken, let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Error with account: ", err)
                AlertBox.sendAlert(boxMessage: "Error logging in with Google Credenitals" , presentingController: self)
                return
            }
            guard let uid = user?.uid, let email = user?.email, let user = user else { return }
            //let firebaseRef = Database.database()
            let values = ["Email": email]
            let userReference = Database.database().reference().child("Users").child(uid)
            Database.database().reference().observeSingleEvent(of: .value, with: { (snapshot) in
                let userDataString = "Users/" + uid + "/Cities"
                if snapshot.hasChild(userDataString) {
                    //send to returning page
                    //UserData.sharedInstance.didLogin(user: user)
                    print("returning user")
                    self.userData.didLogin(user: user, newUser: false)
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
                        self.userData.didLogin(user: user, newUser: true)
                        //let changeRequest = user.createProfileChangeRequest()
                        self.performSegue(withIdentifier: "newUser", sender: self)
                        print("Created user profile")
                        //}
                    })
                }
            })
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        if (error != nil ) {
            print(Error.self)
        }
    }
}

