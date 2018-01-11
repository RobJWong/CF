//
//  InitalViewController.swift
//  Wanderlist
//
//  Created by Robert Wong on 12/11/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class InitalViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var userID : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x:16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is SavedLocationsViewController {
//            let savedLocationsVC = segue.destination as? SavedLocationsViewController
//            savedLocationsVC?.userID = userID
//        }
        if segue.destination is SaveLocationTableViewController {
            let saveLocationTVC = segue.destination as? SaveLocationTableViewController
            saveLocationTVC?.userID = userID
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //display error message
        if let err = error {
            print("Failed to log into google", err ?? "")
        }
        //if no error create token to authenticate user
        print("Logged in with google", user ?? "")
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        //log in with user credenitals to google
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print ("Failed to create a Firebase user with Google credentials" , err ?? "")
            }
            guard let uid = user?.uid, let email = user?.email else { return }
            print("Logged in with ", uid ?? "" )
            self.userID = uid
            let firebaseRef = Database.database()
            let values = ["Email": email]
            let userReference = firebaseRef.reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/").child("Users").child(uid)
            firebaseRef.reference().observeSingleEvent(of: .value, with: {(snapshot) in
                let userDataString = "Users/" + uid
                print(userDataString)
                if snapshot.hasChild(userDataString) {
                    print("user was created before")
                    //let savedSearchesVC = SavedLocationsViewController()
                    //savedSearchesVC.userID = uid
                    //print(uid)`
                    //let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    self.performSegue(withIdentifier: "test", sender: nil)
                }
                else {
                    userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                        if let user = user {
                            let changeRequest = user.createProfileChangeRequest()
                            //let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            self.performSegue(withIdentifier: "OnboardingSegue", sender: nil)
                        }
                    })
                }
            })
        })
    }
            
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        showEmailAddress()
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: {(user, error) in
            if error != nil {
                print("Access token error", error ?? "")
                return
            }
            print("Logged in with facebook user")
        })
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start(completionHandler: {(connection, results, err) in
            if err != nil {
                print("Failed to start graph request", err ?? "")
                return
            }
            print(results ?? "")
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
