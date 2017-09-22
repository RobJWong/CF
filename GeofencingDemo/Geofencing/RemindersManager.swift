//
//  RemindersManager.swift
//  Geofencing
//
//  Created by Hesham Abd-Elmegid on 3/23/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RemindersManager: NSObject {

    static let shared = RemindersManager()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let userDefaultsKey = "RemindersUserDefaultsKey"
    let defaultRadius: Double = 500
    
    func updateLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
        
    func reminders() -> [Reminder] {
        if let remindersData  = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data {
            let reminders = NSKeyedUnarchiver.unarchiveObject(with: remindersData) as! [Reminder]
            
            return reminders
        }
        
        return [Reminder]()
    }
    
    func add(reminder: Reminder) {
        var reminders = self.reminders()
        reminders.append(reminder)
        
        let remindersData = NSKeyedArchiver.archivedData(withRootObject: reminders)
        UserDefaults.standard.set(remindersData, forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
        let region = CLCircularRegion(center: reminder.coordinate, radius: defaultRadius, identifier: reminder.identifier)
        region.notifyOnEntry = true
        
        locationManager.startMonitoring(for: region)
    }
    
    func delete(reminderAtIndex index: Int) {
        var reminders = self.reminders()
        let reminderIdentifier = reminders[index].identifier
        
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion, circularRegion.identifier == reminderIdentifier {
                locationManager.stopMonitoring(for: circularRegion)
            }
        }
        reminders.remove(at: index)
        
        let remindersData = NSKeyedArchiver.archivedData(withRootObject: reminders)
        UserDefaults.standard.set(remindersData, forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
}

extension RemindersManager: CLLocationManagerDelegate  {
    func locationManager (_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        for reminder in reminders() {
            if reminder.identifier == region.identifier {
                showAlert(reminder: reminder)
            }
        }
    }
    
    func showAlert(reminder: Reminder) {
        print(reminder.text)
        let alertController = UIAlertController(title: "Reminder", message: reminder.text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
