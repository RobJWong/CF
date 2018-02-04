//
//  Created by Robert Wong on 2/3/18.
//  Copyright © 2018 CareerFoundry. All rights reserved.
//
//  ViewController.swift
//  ShareExtensionDemo


import UIKit
import SafariServices

class LinksViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var watchListButton: UIBarButtonItem!
    
    @IBAction func changeListButton(_ sender: Any) {
        if watchListButton.title == "List 2" {
            userDefaultsKey = "LinksUserDefaultsKey2"
            watchListButton.title = "List 1"
            self.title = "List 2"
            tableView.reloadData()
        } else {
            userDefaultsKey = "LinksUserDefaultsKey"
            watchListButton.title = "List 2"
            self.title = "List 1"
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List 1"
        NotificationCenter.default.addObserver(self, selector: #selector(LinksViewController.appBecomeActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil )
        
    }
    
    @objc func appBecomeActive() {
        
        tableView.reloadData()
    }
    
    var userDefaultsKey = "LinksUserDefaultsKey"
    
    var links: Array<String> {
        get {
            let userDefaults = UserDefaults(suiteName: "group.com.careerfoundry.ShareExtDemo")
            if let links = userDefaults?.object(forKey: userDefaultsKey) as! Array<String>? {
                return links
            }
            
            return []
        }
        set {
            let userDefaults = UserDefaults(suiteName: "group.com.careerfoundry.ShareExtDemo")
            userDefaults?.set(newValue, forKey: userDefaultsKey)
            userDefaults?.synchronize()
        }
    }
    
    @IBAction func tappedAddButton(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "New Link", message: "Add link to save for later.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let link = alertController.textFields?.first?.text {
                self.links.append(link)
                self.tableView.reloadData()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Link"
            textField.keyboardType = .URL
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
        cell.textLabel?.text = links[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openURL(links[(indexPath as NSIndexPath).row])
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) , urlString.lowercased().hasPrefix("http://") || urlString.lowercased().hasPrefix("https://") else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)
    }
    
}

