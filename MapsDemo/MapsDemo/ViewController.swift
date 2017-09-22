//
//  ViewController.swift
//  MapsDemo
//
//  Created by Robert Wong on 9/21/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let startLocation = CLLocationCoordinate2D(latitude: 40.6892494, longitude: -74.0466891)
        let endLocation = CLLocationCoordinate2D(latitude: 40.7484405, longitude: -73.9878531)
        
        let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
        let endPlacemark = MKPlacemark(coordinate: endLocation, addressDictionary: nil)
        
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let endMapItem = MKMapItem(placemark: endPlacemark)
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.title = "Statue of Liberty National Monument"
        
        if let location = startPlacemark.location {
            startAnnotation.coordinate = location.coordinate
        }
        
        let endAnnotation = MKPointAnnotation()
        endAnnotation.title = "Empire State Building"
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

