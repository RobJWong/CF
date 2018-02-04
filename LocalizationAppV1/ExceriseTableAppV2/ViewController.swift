//
//  ViewController.swift
//  ExceriseTableAppV2
//
//  Created by Robert Wong on 7/9/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [ExceriseSet]()
    
    var otherItems = [ExceriseSet]()
    var allItems = [[ExceriseSet]]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return items.count
        //return allItems[section].count
        
        let addedRow = isEditing ? 1 :0
        
        return allItems[section].count + addedRow
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let setString = NSLocalizedString("Set", comment: "")
        return "\(setString) #\(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row >= allItems[indexPath.section].count, isEditing{
            cell.textLabel?.text = NSLocalizedString("Add Random Exercise", comment: "")
            cell.detailTextLabel?.text = nil
        } else {
            let item = allItems[indexPath.section][indexPath.row]
            
            //cell.textLabel?.text = item.exceriseName
            cell.textLabel?.text = NSLocalizedString(item.exceriseName, comment: "")
            cell.detailTextLabel?.text = String(item.reps)
    
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //        if editingStyle == .delete {
        //            allItems[indexPath.section].remove(at: indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //        }
        
        if editingStyle == .delete {
            allItems[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            let newData = ExceriseSet()
            allItems[indexPath.section].append(newData)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count {
            return .insert
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sectionItems = allItems[indexPath.section]
        if isEditing && indexPath.row < sectionItems.count {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = allItems[sourceIndexPath.section][sourceIndexPath.row]
        allItems[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        if sourceIndexPath.section == destinationIndexPath.section {
            allItems[sourceIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
        } else {
            allItems[destinationIndexPath.section].insert(itemToMove, at:destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let sectionItems = allItems[proposedDestinationIndexPath.section]
        if proposedDestinationIndexPath.row >= sectionItems.count {
            return IndexPath(row: sectionItems.count - 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = IndexPath(row: sectionItems.count, section: index)
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = IndexPath(row: sectionItems.count, section: index)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        automaticallyAdjustsScrollViewInsets = false
        for i in 1...12 {
            items.append(ExceriseSet())
        }
        
        for i in 1...12 {
            otherItems.append(ExceriseSet())
        }
        allItems.append(items)
        allItems.append(otherItems)
        
        tableView.allowsSelectionDuringEditing = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

