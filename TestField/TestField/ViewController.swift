//
//  ViewController.swift
//  TestField
//
//  Created by Robert Wong on 11/20/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var userSettings = [Test]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            userSettings = results as! [Test]
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
    }
    
    @IBAction func saveCoreData(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Test", in: context)
        
        let user = Test(entity: entity!, insertInto: context)
        user.testData = true
        appDelegate.saveContext()
        userSettings.append(user)

    }
    
    @IBAction func showCoreData(_ sender: UIButton) {
        let user = userSettings[0]
        print(user.testData)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

