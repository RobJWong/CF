//
//  ViewController.swift
//  PropertyRetrivalAppV1
//
//  Created by Robert Wong on 8/29/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveData(_ sender: UIButton) {
        do {
            if let nameData = nameField.text, let ageData = ageField.text {
                let morePeopleData = ["Name": "\(nameData)", "Age" : "\(ageData)"] as [String: Any]
                let finalPeopleData = [morePeopleData]
                let serializedData = try PropertyListSerialization.data(fromPropertyList: finalPeopleData, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
                let document = try fileManager.url(for:FileManager.SearchPathDirectory.documentDirectory, in:FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
                let file = document.appendingPathComponent("final_people.plist")
                try serializedData.write(to: file)
                //print(document)
            }
        } catch {
                print("error handling data setup")
        }
    }
    @IBAction func showData(_ sender: UIBarButtonItem) {
        do {
            let documents = try fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            let url = URL(string: "final_people.plist", relativeTo: documents)
            var plistFormat = PropertyListSerialization.PropertyListFormat.xml
            let plistData = try Data(contentsOf: url!)
            let people = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &plistFormat) as! [Dictionary<String, Any>]
            print(people)
            let alertController = UIAlertController(title: "Displaying previous data", message: ("\(people[0]["Name"]!) \(people[0]["Age"]!)"), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Done", style: .default)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } catch {
            print("unable to read data")
        }
        
    }


}


/*let alertController = UIAlertController(title: "Done", message: "Saved", preferredStyle: .alert)
let doneAction = UIAlertAction(title: "Done", style: .default)
alertController.addAction(doneAction)
present(alertController, animated: true, completion: nil) */
