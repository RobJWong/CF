//
//  ExploreListViewController.swift
//  Wanderlist
//
//  Created by Robert Wong on 1/6/18.
//  Copyright © 2018 Robert Wong. All rights reserved.
//

import UIKit
import Firebase

class ExploreListViewController: UIViewController {
    
    var selectedCity : String?
    var presetData = [PrepopulateTestData3]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupSavedLocations() {(presetData) in
            DispatchQueue.main.async(execute: {
                self.testCompletion(presetLocations: presetData)
            })
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 450
    }
    
    func testCompletion(presetLocations: [PrepopulateTestData3]) {
        self.presetData = presetLocations
        self.tableView.reloadData()
    }
    
    func setupSavedLocations(completion: @escaping ([PrepopulateTestData3]) -> ()) {
        var presetDataSet = [PrepopulateTestData3]()
        let firebaseRef = Database.database()
        guard let selectedCity = selectedCity else { return }
        firebaseRef.reference().child("Preset").child(selectedCity).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: NSObject] {
                for (key, value) in dictionary {
                    guard let address = value.value(forKey: "Address") as? String, let description = value.value(forKey: "Description") as? String, let imageLink = value.value(forKey: "Image") as? String, let name = value.value(forKey: "Name") as? String, let notes = value.value(forKey: "Notes") as? String else {
                        print("issue with data, please check")
                        return
                    }
                    let dataSet = PrepopulateTestData3(address: address, description: description, imageLink: imageLink, name: name, notes: notes)
                    //print("This is the data set: ", dataSet)
                    //print("This is an attempt to extract address from dataSet: ", dataSet.address)
                    presetDataSet.append(dataSet)
                    //print("This is the appended presetDataSet: ", presetDataSet)
                    //print("is an attempt to get address from presetDataset: ", presetDataSet[0].address)
                    completion(presetDataSet)
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ExploreListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presetData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TestTableViewCell
        // Configure the cell...
        //cell.locationAdddress.text = presetData[indexPath.row].address
        cell.locationImage.image = UIImage(named: "TestImage")
        //cell.locationDescription.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris at vehicula mauris, non hendrerit elit."
        //cell.locationDescription.text = presetData[indexPath.row].description
//        cell.locationImage.text = presetData[indexPath.row].imageLink
//        cell.locationName.text = presetData[indexPath.row].name
//        cell.locationNotes.text = presetData[indexPath.row].address
        return cell
    }
        
}
