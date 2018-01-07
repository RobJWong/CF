//
//  TestViewController.swift
//  
//
//  Created by Robert Wong on 12/30/17.
//

import UIKit

class TestViewController: UIViewController {
    
    //let testData = PrepopulateTestData.obtainData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

//extension TestViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return testData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TestTableViewCell
//        let testDataIndex = testData[indexPath.row]
//        cell.locationAdddress.text = testDataIndex.address
//        cell.locationDescription.text = testDataIndex.description
//        cell.locationName.text = testDataIndex.name
//        cell.locationNotes.text = testDataIndex.notes
//        
//        return cell
//    }
//}

