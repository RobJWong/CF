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
import Alamofire
import SVProgressHUD

class LoginViewContoller: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate{
    
    var userData = UserData()
    
    @IBOutlet weak var googleLoginView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let googleLogin = UITapGestureRecognizer(target: self, action: #selector(googleLoginTapped(_:)))
        googleLoginView.isUserInteractionEnabled = true
        googleLoginView.addGestureRecognizer(googleLogin)
    }
    
    @objc func googleLoginTapped(_ sender: UITapGestureRecognizer) {
        if NetworkReachabilityManager()!.isReachable {
            googleLoginView.isUserInteractionEnabled = false
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().signIn()
        } else {
            AlertBox.sendAlert(boxMessage: "Unable to connect to the internet. Please check connectivity before using app", presentingController: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SVProgressHUD.dismiss()
        if segue.identifier == "newUser" {
            let navVC = segue.destination as? UINavigationController
            let oVC = navVC?.viewControllers.first as! OnboardCitySelect
            oVC.userData = userData
        }
        if segue.identifier == "returningUser" {
            let navVC = segue.destination as? UINavigationController
            let rVC = navVC?.viewControllers.first as! ReturningUserCityTableViewController
            rVC.userData = userData
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Error signing in: ", err)
            googleLoginView.isUserInteractionEnabled = true
            return
        }
        SVProgressHUD.show(withStatus: "Logging in")
        guard let idToken = user.authentication.idToken, let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Error with account: ", err)
                AlertBox.sendAlert(boxMessage: "Error logging in with Google Credenitals" , presentingController: self)
                return
            }
            guard let uid = user?.uid, let email = user?.email, let user = user else { return }
            let values = ["Email": email]
            let userReference = Database.database().reference().child("Users").child(uid)
            Database.database().reference().observeSingleEvent(of: .value, with: { (snapshot) in
                let userDataString = "Users/" + uid + "/Cities"
                if snapshot.hasChild(userDataString) {
                    print("returning user")
                    self.userData.didLogin(user: user, newUser: false)
                    self.performSegue(withIdentifier: "returningUser", sender: self)
                }
                else {
                    userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            AlertBox.sendAlert(boxMessage: "Error updating Firebase DB" , presentingController: self)
                            return
                        }
                        self.userData.didLogin(user: user, newUser: true)
                        self.performSegue(withIdentifier: "newUser", sender: self)
                        print("Created user profile")
                    })
                }
            })
        })
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("Dismissed")
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("Dispatch")
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil ) {
            print(Error.self)
        }
    }
}

