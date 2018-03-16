//
//  UserListTableViewController.swift
//  CheapMessengerAppV1
//
//  Created by Robert Wong on 10/1/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [Users]()
    
    func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
        })
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let users = Users()
                users.name = dictionary["name"] as? String
                users.email = dictionary["email"] as? String
                print(users.name, users.email)
                self.users.append(users)
                DispatchQueue.main.async (execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserName()
        fetchUsers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItems
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //channels = ModelController.sharedInstance.getChannels()
        //tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "User", for: indexPath)
            let user = users[indexPath.row]
            cell.detailTextLabel?.text = user.email
            cell.textLabel?.text = user.name
            return cell
    }
}
