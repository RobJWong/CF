//
//  TestViewController.swift
//  
//
//  Created by Robert Wong on 12/30/17.
//

import UIKit
import GoogleSignIn
import Firebase

class TestViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print ("Failed to login into Google: ", err ?? "")
            return
        }
        print("Successfully loged in Google: ", user ?? "" )
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print ("Failed to create Firebase user with Google Account: ", err ?? "")
                return
            }
            guard let uid = user?.uid, let email = user?.email else { return }
            print("Successfully logged into Firebase with Google Account: ", uid ?? "")
            let ref = Database.database().reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/")
            //let userReference = ref.child("users").child(uid)
            let userReference = ref.root.child("users").child(uid)
            let values = ["email": email, "name": user?.displayName]
            userReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                if let user = user {
                    print("connected to firebase db")
                }
            })
        })
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x:16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
