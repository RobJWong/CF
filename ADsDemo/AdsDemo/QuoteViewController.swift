//
//  ViewController.swift
//  WidgetDemo
//
//  Created by Hesham Abd-Elmegid on 6/27/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit
import GoogleMobileAds

class QuoteViewController: UIViewController {
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let networking = Networking()
    
    override func viewDidAppear(_ animated: Bool) {
        getNewQuote(.Movies)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "ca-app-pub-1781338805922813/1571570694"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
    
    func getNewQuote(_ type: Networking.QuoteType) {
        quoteLabel.text = nil
        authorLabel.text = nil
        activityIndicator.startAnimating()
        
        networking.randomMoviesQuote(type) { (quote, error) in
            if let quote = quote {
                DispatchQueue.main.async {
                    self.quoteLabel.text = quote.text
                    self.authorLabel.text = quote.author
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func newQuoteButtonTapped(_ sender: AnyObject) {
        let quoteType = quoteTypeForSelectedSegmentedControlIndex()
        getNewQuote(quoteType)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
        let quoteType = quoteTypeForSelectedSegmentedControlIndex()
        getNewQuote(quoteType)
    }
    
    func quoteTypeForSelectedSegmentedControlIndex() -> Networking.QuoteType {
        if segmentedControl.selectedSegmentIndex == 0 {
            return .Movies
        } else {
            return .FamousPeople
        }
    }
}

