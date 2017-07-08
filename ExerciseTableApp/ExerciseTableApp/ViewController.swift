//
//  ViewController.swift
//  ExerciseTableApp
//
//  Created by Robert Wong on 7/7/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items = [DataSet]()
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //let addedRow = isEditing ? 1 : 0
        
        //return items.count + addedRow
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.date
        
        return cell
        
//        if isEditing {
//            cell.textLabel?.text = "New Entry"
//        } else {
//            let item = items[indexPath.row]
//            cell.textLabel?.text = item.name
//            cell.detailTextLabel?.text = item.date
//        }
//        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            //items.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
        
//        if editing {
//            tableView.beginUpdates()
//            let indexPath = IndexPath(index: items.count)
//            tableView.insertRows(at: [indexPath], with: .fade)
//            tableView.endUpdates()
//            tableView.setEditing(true, animated: true)
//        } else {
//            tableView.beginUpdates()
//            let indexPath = IndexPath(index: items.count)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.endUpdates()
//            tableView.setEditing(false, animated: true)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        automaticallyAdjustsScrollViewInsets = false
        tableView.allowsSelectionDuringEditing = true
        for count in 1...10 {
            items.append(DataSet())
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

