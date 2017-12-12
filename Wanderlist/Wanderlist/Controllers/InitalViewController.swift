//
//  InitalViewController.swift
//  Wanderlist
//
//  Created by Robert Wong on 12/11/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CoreData

class InitalViewController: UIViewController {
    
    var userSettings = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            userSettings = results as! [User]
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            if userSettings.isEmpty {
                print("new user")
                let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
                self.present(onboardVC, animated: true, completion: nil)
            } else {
                let savedLocationsVC = storyboard.instantiateViewController(withIdentifier: "SavedLocationsViewController") as! SavedLocationsViewController
                self.present(savedLocationsVC, animated: true, completion: nil)
                print("returning user")
            }
//            if isValidIndex == true {
//                print("returning user")
//            } else {
//                print("new user")
//            }
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
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

//do {
//                let userData = try userSettings[0].firstTimeUser
//                let savedLocationsVC = storyboard.instantiateViewController(withIdentifier: "SavedLocationsViewController") as! SavedLocationsViewController
//                self.present(savedLocationsVC, animated: true, completion: nil)
//            } catch {
//                let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
//                self.present(onboardVC, animated: true, completion: nil)
//            }
//            if (userSettings[0].firstTimeUser == false) {
//            if (userSettings == nil || userSettings[0].firstTimeUser != false) {
//                let vc2 = storyboard.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
//                self.present(vc2, animated: true, completion: nil)
//            } else {
//                let vc = storyboard.instantiateViewController(withIdentifier: "SavedLocationsViewController") as! SavedLocationsViewController
//                self.present(vc, animated: true, completion: nil)
//}
