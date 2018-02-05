//
//  UserTableViewController.swift
//  CheapMessengerAppV1
//
//  Created by Robert Wong on 10/20/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class UserTableViewController: UITableViewController {
    
    var users = [Users]()
    var userEmail: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserName()
        fetchUsers()
    }
    
    @IBAction func userLogout(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            AuthenticationManager.sharedInstance.loggedIn = false
            let presentingViewController = self.presentingViewController
            self.dismiss(animated: false, completion: {
                presentingViewController!.dismiss(animated: true, completion: nil)
            })
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
    func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
                self.userEmail = dictionary["email"] as? String
            }
        })
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let users = Users()
                users.name = dictionary["name"] as? String
                users.email = dictionary["email"] as? String
                users.userIdKey = snapshot.key as? String
                if self.userEmail != users.email {
                    self.users.append(users)
                    DispatchQueue.main.async (execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        }, withCancel: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "User", for: indexPath)
            let user = users[indexPath.row]
            cell.detailTextLabel?.text = user.email
            cell.textLabel?.text = user.name
            return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToChat") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let userInfo = users[indexPath.row]
                let controller = segue.destination as! ChatViewController
                controller.users = userInfo
            }
        }
    }
}
