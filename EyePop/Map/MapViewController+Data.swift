//
//  MapViewController+Data.swift
//  Faswaldo
//
//  Created by Gurinder Singh on 1/26/19.
//  Copyright © 2019 BinaryBros. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import CoreLocation

extension MapViewController {
    
    func addLocations() {
        //TODO: can do locations.filter.blah
        locations.forEach { (location) in
            let annotation = Annotation()
            annotation.title = location.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.instagramURL = location.instagramURL
            annotation.subtitle = location.category
            switch location.category.lowercased() {
                case "public place":
                    annotation.color = UIColor.orange
                    annotation.type = .publicPlace
                case "food/drink":
                    annotation.color = UIColor.blue
                    annotation.type = .foodPlace
                case "food":
                    annotation.color = UIColor.purple
                    annotation.type = .foodPlace
                case "nature":
                    annotation.color = UIColor.green
                    annotation.type = .naturePlace
                case "historic":
                    annotation.color = UIColor.gray
                default:
                    annotation.color = UIColor.white
            }
            mapView.addAnnotation(annotation)
        }
        
//        let annotation = Annotation()
//        annotation.title = "Central Park"
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.7829, longitude: -73.9654)
//        annotation.instagramURL = "https://www.instagram.com/explore/locations/12318445/central-park/?hl=en"
//        mapView.addAnnotation(annotation)
//
//        let annotation2 = Annotation()
//        annotation2.title = "One World Observatory"
//        annotation2.coordinate = CLLocationCoordinate2D(latitude: 40.7133, longitude: -74.0134)
//        annotation2.instagramURL = "https://www.instagram.com/explore/locations/1002377079/one-world-observatory/?hl=en"
//        mapView.addAnnotation(annotation2)
//
//        let annotation3 = Annotation()
//        annotation3.title = "DUMBO Washinton Street"
//        annotation3.coordinate = CLLocationCoordinate2D(latitude: 40.703190, longitude: -73.989570)
//        annotation3.instagramURL = "https://www.instagram.com/explore/locations/2062088733816813/washington-street-dumbo/?hl=en"
//        mapView.addAnnotation(annotation3)
//
//        let annotation4 = Annotation()
//        annotation4.title = "Habana Outpost"
//        annotation4.coordinate = CLLocationCoordinate2D(latitude: 40.686430, longitude: -73.974170)
//        annotation4.instagramURL = "https://www.instagram.com/explore/locations/14468/habana-outpost/?hl=en"
//        mapView.addAnnotation(annotation4)
//
//        let annotation5 = Annotation()
//        annotation5.title = "The Bushwick Collective"
//        annotation5.coordinate = CLLocationCoordinate2D(latitude: 40.707620, longitude: -73.921800)
//        annotation5.instagramURL = "https://www.instagram.com/explore/locations/17485210/the-bushwick-collective/?hl=en"
//        mapView.addAnnotation(annotation5)
//
//        let annotation6 = Annotation()
//        annotation6.title = "Coney Island Beach Boardwalk"
//        annotation6.coordinate = CLLocationCoordinate2D(latitude: 40.574970, longitude: -73.963140)
//        annotation6.instagramURL = "https://www.instagram.com/explore/locations/493789784394748/coney-island-beach-boardwalk/?hl=en"
//        mapView.addAnnotation(annotation6)
        
    }
}
