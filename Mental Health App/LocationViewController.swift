//
//  LocationViewController.swift
//  Mental Health App
//
//  Created by Federico Brandt on 3/12/20.
//  Copyright © 2020 Federico Brandt. All rights reserved.
//
//GPS Data Extraction Screen
//It is to be noted that this class' functionality is not complete
//Data extraction works but it isn't written onto any file due to the fact that
//it is yet to be implemented with a timer to extract data every set amount of minutes
//Current model works to extract GPS coordinates (longitude and latitude) every second.

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    //Map View Initialization
    @IBOutlet weak var Map_Loc: MKMapView!
    //Location manager
    let manager = CLLocationManager()
    
    //Function that extracts current coordinates for user and prints them to terminal
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation,span: span)
        
        print(location.coordinate.longitude)
        print(location.coordinate.latitude)
        
        self.Map_Loc.setRegion(region, animated: true)
        self.Map_Loc.showsUserLocation = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.desiredAccuracy = kCLLocationAccuracyBest //Set accuracy of location extraction
        manager.requestAlwaysAuthorization() //Request for background app data extraction at all times
        manager.allowsBackgroundLocationUpdates = true //Request for app running without being active
        manager.showsBackgroundLocationIndicator = false
        manager.pausesLocationUpdatesAutomatically = false //Request to never stop location extraction
        manager.startUpdatingLocation() //Initialize location extraction
        manager.delegate = self

        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
