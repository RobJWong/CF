//
//  SavedLocationsViewController.swift
//  Wanderlist
//
//  Created by Robert Wong on 12/11/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class SavedLocationsViewController: UIViewController {
    
    var userID: String?
    var myActivityIndicator : UIActivityIndicatorView?
    var testArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSavedLocations() { (savedData) in
            DispatchQueue.main.async(execute: {
                self.testCompletion(locations: savedData)
            })
        }
        
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        self.view.addSubview(myActivityIndicator)
        self.myActivityIndicator = myActivityIndicator
    }
    
    func testCompletion(locations:[String]) {
        myActivityIndicator?.stopAnimating()
        myActivityIndicator?.removeFromSuperview()
        print("Show updated locations: \(locations)")
        self.testArray = locations
    }
    
    func setupSavedLocations(completion: @escaping ([String]) -> ()) {
        guard let user = userID else { return }
        let databaseRef = Database.database().reference(fromURL: "https://wanderlist-67ec0.firebaseio.com/Users/pPXlAljzhDRDwn7OTtzYetMg3sk2/City")
        var dataTest : [String] = []
        databaseRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let childString = "Users/" + user + "/City"
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                dataTest.append(key)
            }
            completion(dataTest)
        })
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
