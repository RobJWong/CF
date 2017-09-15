//
//  ViewController.swift
//  CoreDataAppV1
//
//  Created by Robert Wong on 9/14/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var userData = [NSManagedObject]()
    
    @IBAction func saveDataButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
        let personData = NSManagedObject(entity: entity!, insertInto: context)
        
        personData.setValue(usernameTextField.text!, forKey: "username")
        personData.setValue(passwordTextField.text!, forKey: "password")
        appDelegate.saveContext()
        userData.append(personData)
        print(userData)
        
        let alertController = UIAlertController(title: "Entered", message: "Entered", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {
            (alert) in
            print("User tapped Ok")
            self.passwordTextField.text = ""
            self.usernameTextField.text = ""
        }
        alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceRect = sender.frame
        alertController.popoverPresentationController?.sourceView = view
        
        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")

        do {
            let results = try managedContext.fetch(fetchRequest)
            userData = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
    }


}

