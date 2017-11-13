//
//  ViewController.swift
//  DebuggingExercise
//
//  Created by Hesham Abd-Elmegid on 7/19/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var items = [String]()
    let itemsCount = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var i = 1
        while i <= itemsCount {
            items.append("\(i)")
            i = i + 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsViewController = segue.destination as! DetailsViewController
        detailsViewController.item = sender as? String
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PushDetails", sender: items[indexPath.row])
    }

}

