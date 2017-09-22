//
//  Reminder.swift
//  Geofencing
//
//  Created by Hesham Abd-Elmegid on 3/23/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit
import MapKit

class Reminder: NSObject, NSCoding {
    let text: String
    let coordinate: CLLocationCoordinate2D
    let identifier: String
    
    convenience init(text: String, coordinate: CLLocationCoordinate2D) {
        self.init(text: text, coordinate: coordinate, identifier: NSUUID().uuidString)
    }
    
    init(text: String, coordinate: CLLocationCoordinate2D, identifier: String) {
        self.text = text
        self.coordinate = coordinate
        self.identifier = identifier
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let text = aDecoder.decodeObject(forKey: "text") as! String
        let longitude = aDecoder.decodeDouble(forKey: "longitude")
        let latitude = aDecoder.decodeDouble(forKey: "latitude")
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let identifier = aDecoder.decodeObject(forKey: "identifier") as! String
        
        self.init(text: text, coordinate: coordinate, identifier: identifier)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(coordinate.longitude, forKey: "longitude")
        aCoder.encode(coordinate.latitude, forKey: "latitude")
        aCoder.encode(identifier, forKey: "identifier")
    }

}
