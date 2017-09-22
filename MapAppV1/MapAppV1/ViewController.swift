//
//  ViewController.swift
//  MapAppV1
//
//  Created by Robert Wong on 9/22/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
                self.getLocationDetails(placemark:placemark, location: manager.location!)
            } else {
                print("Error retrieving data")
            }
        }
    }
    
    func getLocationDetails(placemark: CLPlacemark, location: CLLocation) {
        locationManager.stopUpdatingLocation()
        //print("Latitude: \(location.coordinate.latitude)")
        //print("Longitude: \(location.coordinate.longitude)")
        //userLat = location.coordinate.latitude
        //userLong = location.coordinate.longitude
        
        showRoute(userLat: location.coordinate.latitude, userLong: location.coordinate.longitude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showRoute(userLat: Double, userLong: Double) {
        let startLocation = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
        let endLocation = CLLocationCoordinate2D(latitude: 40.764593, longitude: -73.810638)
        
        let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
        let endPlacemark = MKPlacemark(coordinate: endLocation, addressDictionary: nil)
        
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let endMapItem = MKMapItem(placemark: endPlacemark)
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.title = "Current Location"
        
        if let location = startPlacemark.location {
            startAnnotation.coordinate = location.coordinate
        }
        
        let endAnnotation = MKPointAnnotation()
        endAnnotation.title = "Picnic Garden"
        
        if let location = endPlacemark.location {
            endAnnotation.coordinate = location.coordinate
        }
        
        mapView.showAnnotations([startAnnotation, endAnnotation], animated: true )
        
        let directionReq = MKDirectionsRequest()
        directionReq.source = startMapItem
        directionReq.destination = endMapItem
        directionReq.transportType = .automobile
        
        let directions = MKDirections(request: directionReq)
        
        directions.calculate {
            (res, err) -> Void in
            
            guard let res = res else {
                if let err = err {
                    print("Error: \(err)")
                }
                
                return
            }
            
            let route = res.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayRenderer = MKPolylineRenderer(overlay: overlay)
        overlayRenderer.strokeColor = .red
        overlayRenderer.lineWidth = 4.0
        
        return overlayRenderer
    }
}

