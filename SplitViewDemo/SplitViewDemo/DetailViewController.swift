//
//  DetailViewController.swift
//  SplitViewDemo
//
//  Created by Robert Wong on 8/18/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailViewLabel: UILabel!
    
    var item: Item?
    var loginCheck : Bool?
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginScreen") as UIViewController
//        self.present(loginVC, animated: false, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let detailItem = self.item {
            navigationItem.title = detailItem.title
            detailViewLabel.text = detailItem.text
        }
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

extension DetailViewController : LoginCheckDelegate {
    func loginCheckFlag(login: String) {
        sectionName.text = selection
        sectionName.textColor = UIColor.black
    }
}

