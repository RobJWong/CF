//
//  AppDelegate.swift
//  Wanderlist
//
//  Created by Robert Wong on 11/29/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //GIDSignIn.sharedInstance().delegate = self
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let err = error {
//            print("Failed to log into google", err ?? "")
//        }
//        print("Logged in with google", user ?? "")
//        guard let idToken = user.authentication.idToken else { return }
//        guard let accessToken = user.authentication.accessToken else { return }
//
//        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//        Auth.auth().signIn(with: credentials, completion: { (user, error) in
//            if let err = error {
//                print ("Failed to create a Firebase user with Google credentials" , err ?? "")
//            }
//            guard let uid = user?.uid, let email = user?.email else { return }
//            print("Logged in with ", uid ?? "" )
//            let ref = Database.database().reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/")
//            let userReference = ref.child("users").child(uid)
//            let values = ["email": email]
//            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//                if err != nil {
//                    print(err)
//                    return
//                }
//                if let user = user {
//                    let changeRequest = user.createProfileChangeRequest()
//                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    self.window?.rootViewController?.performSegue(withIdentifier: "OnboardingSegue", sender: nil)
//                }
//            })
//        })
//    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }
}

