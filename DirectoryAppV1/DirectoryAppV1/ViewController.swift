//
//  ViewController.swift
//  DirectoryAppV1
//
//  Created by Robert Wong on 8/28/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var storedData: UITextField!
    
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showSavedData(_ sender: UIBarButtonItem) {
        do {
            let documents = try self.fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            let url = URL(string: "saved_document.txt", relativeTo: documents)
            let textFromFile = try String(contentsOf: url!)
            
            let alertController = UIAlertController(title: "Displaying previous data", message: ("\(textFromFile)"), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Done", style: .default)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } catch {
            print("Error setting up file manager to show data")
        }
    }
    @IBAction func saveData(_ sender: UIButton) {
        do {
            let documents = try self.fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            let url = URL(string: "saved_document.txt", relativeTo: documents)
            print(documents)
            if let stringToWrite = storedData.text {
                if let url = url {
                    try stringToWrite.write(to: url, atomically: true, encoding: String.Encoding.utf8)
                }
            }
            let alertController = UIAlertController(title: "Done", message: "Saved", preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Done", style: .default)
            alertController.addAction(doneAction)
            present(alertController, animated: true, completion: nil)
            
        } catch {
            print("Error getting path")
        }
    }

}
