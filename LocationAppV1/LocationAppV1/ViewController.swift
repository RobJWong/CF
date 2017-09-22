//
//  ViewController.swift
//  LocationAppV1
//
//  Created by Robert Wong on 9/21/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var latitudeData: UILabel!
    @IBOutlet weak var longitudeData: UILabel!
    @IBOutlet weak var localData: UILabel!
    @IBOutlet weak var postalData: UILabel!
    @IBOutlet weak var regionData: UILabel!
    @IBOutlet weak var countryData: UILabel!
    @IBOutlet weak var streetData: UILabel!
    
    //@IBOutlet weak var locationTextBox: UITextView!
    
    let locationManager = CLLocationManager()
    @IBAction func findLocation(_ sender: UIButton) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if (error != nil) {
                print("Error: " + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                self.displayLocationDetails(placemark:placemark, location: manager.location!)
            } else {
                print("Error retrieving data")
            }
        }
    }
    
    func displayLocationDetails(placemark: CLPlacemark, location: CLLocation) {
        locationManager.stopUpdatingLocation()
        latitudeData.text = String(location.coordinate.latitude)
        longitudeData.text = String(location.coordinate.longitude)
        localData.text = placemark.locality ?? "No local data"
        postalData.text = placemark.postalCode ?? "No postal code"
        regionData.text = placemark.administrativeArea ?? "No regional data"
        countryData.text = placemark.country ?? "No country data"
        let streetNumber = placemark.subThoroughfare ?? "No st. #"
        let streetName = placemark.thoroughfare ?? "No st. name"
        streetData.text = streetNumber + " " + streetName
    }
}

