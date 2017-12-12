//
//  CityTableViewController.swift
//  Wanderlist
//
//  Created by Robert Wong on 12/9/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class CityTableViewControllerDefunct: UITableViewController, UIViewControllerTransitioningDelegate {
    
    var cities: [String] = ["New York City", "Montreal", "San Francisco", "Paris", "Lisbon", "London", "Philadelphia", "Los Angeles", "Boston", "Atlanta"]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return CityPop(presentedViewController: presented, presenting: presenting)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //automaticallyAdjustsScrollViewInsets = false
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
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Goku", size: 33.9)
        cell.textLabel?.textAlignment = .center
        // Configure the cell...

        return cell
    }

}

class CityPop: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        let containerFrame = self.containerView!.frame
        
        return CGRect(x: 0, y: containerFrame.height/3, width: containerFrame.width, height: 2*(containerFrame.height/3))
    }
}
