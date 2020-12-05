//
//  ViewController.swift
//  Mental Health App
//
//  Created by Federico Brandt on 3/9/20.
//  Updated by Belen Carrasco on 28/11/20.
//  Copyright © 2020 Federico Brandt. All rights reserved.
//

import UIKit
import CoreLocation

// ----- UPDATES ------//

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var CandidateID: UITextField!
    
    //Allows keyboard to be hidden if touching anything outside of keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 100.0 // 100m
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
    }
    
    // Receive location information here
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("LocationManager didUpdateLocations: numberOfLocation: \(locations.count)")
        let location:CLLocationCoordinate2D = manager.location!.coordinate
        
        // Save latitude
        var lat  = ""
        lat = String(location.latitude)
        
        // Save longitude
        var long = ""
        long = String(location.longitude)
        
        let fileName = "Location" //For this View we are writing to Location.txt locally
        
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        print("File Path: \(fileURL.path)") //Comment this if you want
        
        //Collect date data
        let formatter : DateFormatter = DateFormatter()
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        formatter.dateFormat = "dd-MM-yy" //write date data in this format
        let myStr : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        
        //Format string to be written
        let writeString = "\(myStr) \(hour):\(minutes):\(seconds) Location: \(lat) - \(long)"
        
        //Write to file
        do{
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }catch let error as NSError{
            print("Failed to write to URL ")
            print(error)
        }
        
        //Read file content. Comment this out if needed
        var ReadString = ""
        do{
            ReadString = try String(contentsOf: fileURL)
        }catch let error as NSError{
            print("Failed to read")
            print(error)
        }
        
        //Print file content. Comment this out if needed
        print("Content: \(ReadString)")
        
        //Upload fileURL to local MAMP server
        func uploadData(_ sender: Any){
            let url = URL(string: "http://localhost:8888/mental_health_app/receive_location.php") // locahost MAMP - change to point to your database server
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            var dataURL = ""
            do{
                dataURL = try String(contentsOf: fileURL)
            }catch let error as NSError{
                print("Failed to read")
                print(error)
            }
            
            let candidateID = "\(CandidateID.text!)"
            
            var dataString = ""
            dataString = "&id=" + candidateID
            dataString = "&location=" + dataURL
            
            let dataD = dataString.data(using: .utf8) // convert to utf8 string
            
            do
            {
                // the upload task, uploadJob, is defined here
                let uploadJob = URLSession.shared.uploadTask(with: request, from: dataD)
                {
                    data, response, error in
                    
                    if error != nil{
                        // display an alert if there is an error inside the DispatchQueue.main.async
                        
                        DispatchQueue.main.async
                        {
                            let alert = UIAlertController(title: "Upload Didn't Work?", message: "Looks like the connection to the server didn't work.  Do you have Internet access?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        if let unwrappedData = data {
                            
                            let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) // Response from web server hosting the database
                            
                            if returnedData == "1" // insert into database worked
                            {
                                
                                // display an alert if no error and database insert worked (return = 1) inside the DispatchQueue.main.async
                                
                                DispatchQueue.main.async
                                {
                                    let alert = UIAlertController(title: "Upload OK?", message: "Looks like the upload and insert into the database worked.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            else
                            {
                                // display an alert if an error and database insert didn't worked (return != 1) inside the DispatchQueue.main.async
                                
                                DispatchQueue.main.async
                                {
                                    let alert = UIAlertController(title: "Upload Didn't Work", message: "Looks like the insert into the database did not worked.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
                uploadJob.resume()
            }
        }
    }
    
    
    // Authorization Changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
}

class ID: NSObject{
    static let shared: ID = ID()
    @IBOutlet var CandidateID: UITextField!
}

// ----- END UPDATES ------ //
