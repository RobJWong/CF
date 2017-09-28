//
//  ViewController.swift
//  ShoppingListCKAppV1
//
//  Created by Robert Wong on 9/25/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CloudKit
import SVProgressHUD

let RecordTypeLists = "Lists"
let RecordTypeItems = "Items"

let SegueList = "List"
let SegueListDetail = "ListDetail"

class ListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddListViewControllerDelegate {
    func controller(controller: AddListViewController, didAddList list: CKRecord) {
        lists.append(list)
        sortLists()
        tableView.reloadData()
        updateView()
    }
    
    func controller(controller: AddListViewController, didUpdateList list: CKRecord) {
        sortLists()
        tableView.reloadData()
    }
    
    static let ListCell = "ListCell"
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var lists = [CKRecord]()
    var selection: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //fetchUserRecordID()
        fetchLists()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "ListDetail" {
            guard let identifier = segue.identifier else { return }
            
            switch identifier {
            case SegueList:
                let listViewController = segue.destination as! ListViewController

                let list = lists[tableView.indexPathForSelectedRow!.row]
                
                listViewController.list = list
            case SegueListDetail:
                let addListViewController = segue.destination as! AddListViewController
                
                addListViewController.delegate = self
                
                if let selection = selection {
                    let list = lists[selection]
                    addListViewController.list = list
                }
            default:
                break
            }
        
    }
    
    private func sortLists() {
        lists.sort {
            var result = false
            let name0 = $0.object(forKey: "name") as? String
            let name1 = $1.object(forKey: "name") as? String
            
            if let listName0 = name0, let listName1 = name1 {
                result = listName0.localizedCaseInsensitiveCompare(listName1) == .orderedAscending
            }
            
            return result
        }
    }

    private func fetchUserRecordID() {
        let defaultContainer = CKContainer.default()
        
        defaultContainer.fetchUserRecordID(completionHandler: {(recordID, error) -> Void in
            if let responseError = error {
                print(responseError)
            } else if let userRecordID = recordID {
                DispatchQueue.main.async(execute: {
                    self.fetchUserRecord(recordID: userRecordID)
                })
            }
        })
    }
    
    private func fetchUserRecord(recordID: CKRecordID) {
        let defaultContainer = CKContainer.default()
        
        let publicDatabase = defaultContainer.publicCloudDatabase
        
        publicDatabase.fetch(withRecordID: recordID) { (record, error) in
            if let responseError = error {
                print(responseError)
            } else if let userRecord = record {
                print(userRecord)
            }
        }
    }
    
    private func setupView() {
        tableView?.isHidden = true
        messageLabel?.isHidden = true
        activityIndicatorView?.startAnimating()
    }
    
    private func fetchLists() {

        let publicDatabase = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: RecordTypeLists, predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        publicDatabase.perform(query, inZoneWith: nil) { (records: [CKRecord]?, error: Error?) in
            DispatchQueue.main.async(execute : {
                self.processResponseForQuery(records: records, error: error as? NSError)
            })
        }
    }
    
    private func processResponseForQuery(records: [CKRecord]?, error: NSError?) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "Error fetching records"
        } else if let records = records {
            lists = records
            
            if lists.count == 0 {
                message = "No records found"
            }
        } else {
            message = "No records found"
        }
        if message.isEmpty {
            tableView.reloadData()
        } else {
            messageLabel.text = message
        }
        updateView()
    }
    
    private func updateView() {
        let hasRecords = lists.count > 0
        
        tableView.isHidden = !hasRecords
        messageLabel.isHidden = hasRecords
        activityIndicatorView.stopAnimating()
    }
    
    private func deleteRecord(list: CKRecord) {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        SVProgressHUD.show()
        publicDatabase.delete(withRecordID: list.recordID) { (recordID, error) in
            DispatchQueue.main.async (execute:{
                SVProgressHUD.dismiss()
                self.processResponseForDeleteRequest(record: list, recordID: recordID, error: error as? NSError)
            })
        }
    }
    
    private func processResponseForDeleteRequest(record: CKRecord, recordID: CKRecordID?, error: NSError?) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "We are unable to delete the list."
            
        } else if recordID == nil {
            message = "We are unable to delete the list."
        }
        
        if message.isEmpty {
            let index = lists.index(of: record)
            
            if let index = index {
                lists.remove(at: index)
                
                if lists.count > 0 {
                    tableView.deleteRows(at: [NSIndexPath(row: index, section: 0) as IndexPath], with: .right)
                    
                } else {
                    messageLabel.text = "No Records Found"
                    
                    updateView()
                }
            }
            
        } else {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete
            else {
                return
        }
        let list = lists[indexPath.row]
        deleteRecord(list: list)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selection = indexPath.row
        performSegue(withIdentifier: SegueListDetail, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)

        cell.accessoryType = .detailDisclosureButton
        
        let list = lists[indexPath.row]
        
        if let listName = list.object(forKey: "name") as? String {

            cell.textLabel?.text = listName
            
        } else {
            cell.textLabel?.text = "-"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}





