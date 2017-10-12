//
//  TodayViewController.swift
//  QuotesWidget
//
//  Created by Robert Wong on 10/10/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit
import NotificationCenter
import QuotesNetworking

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let categoryTypes = ["movies", "famous"]
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    let networking = Networking()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        segmentedControl.addTarget(self, action: #selector(segmentSelectionChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.quoteLabel.text = nil
        self.authorLabel.text = nil
        
        let settingIndex = userDefaults.integer(forKey: "Category")
        segmentedControl.selectedSegmentIndex = settingIndex
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func segmentSelectionChanged() {
        if let category = (segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex))
        {
            print(category)
            let segmentIndex = segmentedControl.selectedSegmentIndex
            userDefaults.set(segmentIndex, forKey: "Category")
            //userDefaults.set(category, forKey: category)
            getQuoteData(category: category)
        }
    }
 
    func getQuoteData(category: String) {
        networking.randomQuote(category: category) { (quote, error) in
            if let quote = quote {
                DispatchQueue.main.async {
                    self.quoteLabel.text = quote.text
                    self.authorLabel.text = quote.author
                }
            }
        }
    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        networking.randomQuote(category: "movies") { (quote, error) in
            guard let quote = quote, error == nil else {
                completionHandler(.failed)
                return
            }
            
            DispatchQueue.main.async {
                self.quoteLabel.text = quote.text
                self.authorLabel.text = quote.author
            }
            
            completionHandler(.newData)
        }
    }
    
}
