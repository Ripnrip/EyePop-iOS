//
//  MapViewController.swift
//  Faswaldo
//
//  Created by Gurinder Singh on 1/14/19.
//  Copyright © 2019 BinaryBros. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import WebKit
import FirebaseDatabase
import UserNotifications
import Pulsator
import AVFoundation
import AVKit

enum LocationType {
    case naturePlace
    case publicPlace
    case foodPlace
    case other
}

class Annotation  :   MKPointAnnotation {
    var tag : Int = 0
    var instagramURL: String = ""
    var color: UIColor = UIColor.white
    var type: LocationType = LocationType.other
}

struct LocationPoint { //TODO: use codable
    let category:String //TODO: use enum
    let instagramURL:String
    let latitude:Double
    let longitude:Double
    let name:String
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationInformationView: UIView!
    @IBOutlet weak var locationImagesCollectionView: UICollectionView!
    
    let locationManager = CLLocationManager()

    let center = UNUserNotificationCenter.current()

    var ref: DatabaseReference?

    var locations:[LocationPoint] = [] //TODO: add didset{ that updates ui.ux
    
    var selectedAnnotation: Annotation?

    var player: AVAudioPlayer?

    //temp using this for request access, this should be requested before the vc is presented with the pretty display
    override func viewWillAppear(_ animated: Bool) {
        //location always
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
        locationManager.delegate = self
        // 1
        locationManager.distanceFilter = 35
        
        // 2
        locationManager.allowsBackgroundLocationUpdates = true
        
        // 3
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true

        //data
        initDataStore()
        
        //collectionView
        locationImagesCollectionView.delegate = self
        locationImagesCollectionView.dataSource = self
        
        locationImagesCollectionView.register(LocationImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
    }
    
    func initDataStore() {
        ref = Database.database().reference(withPath: "places")
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let values = snapshot.value as? [String:AnyHashable]
                let username = values?["name"] as? String ?? ""
                values?.forEach({ (key, value) in
                    guard let dictionary = value as? [String:AnyHashable] else { return } //handle failure?
                    let category:String = dictionary["category"] as? String ?? "N/A"
                    let instagramURL:String = dictionary["instagramURL"] as? String ?? ""
                    let latitude = dictionary["latitude"] as? Double ?? 0.00
                    let longitude = dictionary["longitude"] as? Double ?? 0.00
                    let name = dictionary["name"] as? String ?? "N/A"
                    let location = LocationPoint(category: category, instagramURL: instagramURL, latitude: latitude, longitude: longitude, name: name)
                    self.locations.append(location)
                   // print("the name key is: \(key) \n the value is \(value) ")
                })
                print("the number of locations: \(self.locations.count)")
                self.addLocations()
                //self.add50places()


                // ...
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func add50places() {
        for _ in 0..<50 {
            ref?.childByAutoId().setValue(["latitude": 00.7829,
                                           "longitude":-03.9654,
                                           "instagramURL":"https://www.instagram.com/explore/locations/12318445/central-park/?hl=en",
                                           "category":"Public place",
                                           "name":"Central Park",
                                           "notes":"hecc"]){
                                            (error:Error?, ref:DatabaseReference) in
                                            if let error = error {
                                                print("Data could not be saved: \(error).")
                                                
                                            } else {
                                                print("Data saved successfully!")
                                            }
            }
        }
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            playSound()
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "cashMeOutside", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? Annotation
        print("the details from this pin is: \(self.selectedAnnotation)")
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       // let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "anotherViewController") as! AnotherViewController
        if let atmPin = view.annotation as? Annotation
        {
            let vc = UIViewController()
            let frame = CGRect(x: 0, y: 34, width: vc.view.frame.width, height: vc.view.frame.height-34)
            let webView = WKWebView(frame: frame)
            guard let url = URL(string: atmPin.instagramURL) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
            vc.view.addSubview(webView)
            vc.view.backgroundColor = UIColor.white
            self.navigationController?.pushViewController(vc, animated: true)
            //anotherViewController.currentAtmPin = atmPin
        }
      //  self.navigationController?.pushViewController(anotherViewController, animated: true)
        
    }


//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "Sample"
//
//        if annotation.isKind(of: Annotation.self) {
//            guard let pin = annotation as? Annotation else { return nil }
//
//            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
//
//                // Reuse Annotationview
//
//                annotationView.annotation = pin
//                return annotationView
//            } else {
//
//                // Create Annotation
//
//                let annotationView = MKPinAnnotationView(annotation:pin, reuseIdentifier:identifier)
//                annotationView.isEnabled = true
//                annotationView.canShowCallout = true
//                //annotationView.pinTintColor = pin.color
//                // Here I create the button and add in accessoryView
//
//                let btn = UIButton(type: .detailDisclosure)
//                annotationView.rightCalloutAccessoryView = btn
//
//                //pulse
////                let pulsator = Pulsator()
////                annotationView.layer.addSublayer(pulsator)
////                pulsator.start()
//                let pinImage = UIImage(named: "food")
//                annotationView.image = pinImage
//                return annotationView
//            }
//        }
//        return nil
//    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is Annotation) {
            return nil
        }
        guard let pin = annotation as? Annotation else { return nil }

        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = pin
        }
        
        var pinImage = UIImage(named: "food")

        switch pin.type {
        case .foodPlace:
            pinImage = UIImage(named: "food")
        case .naturePlace:
            pinImage = UIImage(named: "nature")
        case .publicPlace:
            pinImage = UIImage(named: "public")
        default:
            break
        }
        
        annotationView!.image = pinImage
        annotationView?.frame = CGRect(x: 0, y: 0, width: 60, height: 82)

        return annotationView
    }
    
    @IBAction func addMorePlaces(_ sender: Any) {
        let alertController:UIAlertController = UIAlertController(title: "You sure you wanna add more places", message: "yes to confirm", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES COMMADRE", style: .default) { (action) in
            self.add50places()
        }
        let noAction = UIAlertAction(title: "no", style: .destructive, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
