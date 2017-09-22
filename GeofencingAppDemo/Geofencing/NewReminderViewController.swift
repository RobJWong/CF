//
//  NewReminderViewController.swift
//  Geofencing
//
//  Created by Hesham Abd-Elmegid on 3/23/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit
import MapKit

class NewReminderViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewReminderViewController.handleMapTap(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        if let location = RemindersManager.shared.currentLocation {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        }
        userInputGeofencingSetting()

    }
    

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {       
        if let text = textField.text, let coordinate = coordinate {
            let reminder = Reminder(text: text, coordinate: coordinate)
            RemindersManager.shared.add(reminder: reminder)
            dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error",
                                                    message: "Please select a map location.",
                                                    preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func handleMapTap(_ gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        
        coordinate = touchMapCoordinate
        
        print(touchMapCoordinate.latitude)
        print(touchMapCoordinate.longitude)
    }
}

extension NewReminderViewController {
    
    func userInputGeofencingSetting() {
        
        let alertController = UIAlertController(title: "Geofence Setting", message: "Enter radius in meters for alert boundary", preferredStyle: .alert)
        
        let nofityOnEntryAction = UIAlertAction(title: "Notify on Entry", style: .default) { (_) in
            getRadiusInput()
            RemindersManager.shared.notifyOnEntry = true
        }
        let notifyOnExitAction = UIAlertAction(title: "Notify on Exit", style: .default) { (_) in
            getRadiusInput()
            RemindersManager.shared.notifyOnEntry = false
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "25"
            textField.textAlignment = .center
        }
        
        // adding action to dialogbox
        alertController.addAction(nofityOnEntryAction)
        alertController.addAction(notifyOnExitAction)
        
        // presenting the dialog
        present(alertController, animated: true, completion: nil)
        
        // helper
        func getRadiusInput() {
            if let radius = alertController.textFields?[0].text,
                radius.trimmingCharacters(in: .whitespacesAndNewlines) != "",
                let radiusAsDouble = Double(radius) {
                RemindersManager.shared.userInputRadius = radiusAsDouble
            } else {
                // user has entered invalid radius, thus we use defaultRadius
                RemindersManager.shared.userInputRadius = RemindersManager.shared.defaultRadius
            }
        }
    }
}
