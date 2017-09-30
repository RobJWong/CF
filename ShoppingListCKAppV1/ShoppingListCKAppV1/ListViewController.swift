//
//  ListViewController.swift
//  
//
//  Created by Robert Wong on 9/27/17.
//

import UIKit
import CloudKit
import SVProgressHUD

let SegueItemDetail = "ItemDetail"

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddItemViewControllerDelegate {
    
    func controller(controller: AddItemViewController, didAddItem item: CKRecord) {
        items.append(item)
        sortItems()
        tableView.reloadData()
        updateView()
    }
    
    func controller(controller: AddItemViewController, didUpdateItem item: CKRecord) {
        // Sort Items
        sortItems()
        
        // Update Table View
        tableView.reloadData()
    }
    
    static let ItemCell = "ItemCell"
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var list: CKRecord!
    var items = [CKRecord]()
    
    var selection: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = list?.object(forKey: "name") as? String
        // Do any additional setup after loading the view.
        title = list.object(forKey: "name") as? String
        
        setupView()
        fetchItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case SegueItemDetail:
            let addItemViewController = segue.destination as! AddItemViewController
            
            addItemViewController.list = list
            addItemViewController.delegate = self
            
            if let selection = selection {
                let item = items[selection]
                addItemViewController.item = item
            }
        default:
            break
        }
    }
    
    private func setupView() {
        tableView?.isHidden = true
        messageLabel?.isHidden = true
        activityIndicatorView?.startAnimating()
    }
    
    private func updateView() {
        let hasRecords = items.count > 0
        
        tableView.isHidden = !hasRecords
        messageLabel.isHidden = hasRecords
        activityIndicatorView.stopAnimating()
    }
    
    private func fetchItems() {
        let publicDatabase  = CKContainer.default().publicCloudDatabase

        let reference = CKReference(recordID: list.recordID, action: .deleteSelf)
        let query = CKQuery(recordType: RecordTypeItems, predicate: NSPredicate(format: "list == %@", reference))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            DispatchQueue.main.async (execute:{
                self.processResponseForQuery(records: records, error: error as? NSError)
            })
        }
    }
    
    private func processResponseForQuery(records: [CKRecord]?, error: NSError?) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "Error fetching items for list"
        } else if let records = records {
            items = records
            if items.count == 0 {
                message = "No items found"
            }
        } else {
            message = "No items found"
        }
        if message.isEmpty {
            tableView.reloadData()
        } else {
            messageLabel.text = message
        }
        updateView()
    }
    
    private func sortItems() {
        items.sort {
            var result = false
            let name0 = $0.object(forKey: "name") as? String
            let name1 = $1.object(forKey: "name") as? String
            
            if let itemName0 = name0, let itemName1 = name1 {
                result = itemName0.localizedCaseInsensitiveCompare(itemName1) == .orderedAscending
            }
            
            return result
        }
    }
    
    private func deleteRecord(item: CKRecord) {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        SVProgressHUD.show()
        publicDatabase.delete(withRecordID: item.recordID) { (recordID, error) in
            DispatchQueue.main.async (execute: {
                SVProgressHUD.dismiss()
                self.processResponseForDeleteRequest(record: item, recordID: recordID, error: error as? NSError)
            })
        }
    }
    
    private func processResponseForDeleteRequest(record: CKRecord, recordID: CKRecordID?, error: NSError?) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "We are unable to delete the item."
            
        } else if recordID == nil {
            message = "We are unable to delete the item."
        }
        
        if message.isEmpty {
            let index = items.index(of: record)
            
            if let index = index {
                items.remove(at: index)
                
                if items.count > 0 {
                    tableView.deleteRows(at: [NSIndexPath(row: index, section: 0) as IndexPath], with: .right)
                    
                } else {
                    messageLabel.text = "No Items Found"
                    updateView()
                }
            }
            
        } else {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        //cell.accessoryType = .detailDisclosureButton
        
        let item = items[indexPath.row]
        if let itemName = item.object(forKey: "name") as? String {
            cell.textLabel?.text = itemName
        } else {
            cell.textLabel?.text = "-"
        }
        if let itemNumber = item.object(forKey: "number") as? Int {
            // Configure Cell
            cell.detailTextLabel?.text = "\(itemNumber)"
            
        } else {
            cell.detailTextLabel?.text = "1"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        let item = items[indexPath.row]
        deleteRecord(item: item)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        selection = indexPath.row
//        performSegue(withIdentifier: SegueItemDetail, sender: self)
//    }

}
