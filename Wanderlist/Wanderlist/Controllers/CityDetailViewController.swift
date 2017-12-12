//
//  CityDetailViewController.swift
//  Wanderlist
//
//  Created by Robert Wong on 12/11/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CoreData

class CityDetailViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    var citySelect: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let city = citySelect else {
            return
        }
        welcomeLabel.text = "Welcome to \n\(city)"
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
