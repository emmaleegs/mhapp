//
//  Location.swift
//  MyDataMH
//
//  Created by Ashwini Srinivasaprasad on 3/2/20.
//  Copyright © 2020 Ashwini Srinivasaprasad. All rights reserved.
//

import Foundation
import CoreLocation

//to save objects of this class on to the disk we use codable, a feature that lets you encode and decode objects easily

class Location: Codable {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
  }()
  
  var coordinates: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  let latitude: Double    //co ordinates of location
  let longitude: Double   //co ordinates of location
  let date: Date          //date the location was last loggged
  let dateString: String    //human readbale version of date
  let description: String   //human readable version of location
  
  init(_ location: CLLocationCoordinate2D, date: Date, descriptionString: String) {
    latitude =  location.latitude
    longitude =  location.longitude
    self.date = date
    dateString = Location.dateFormatter.string(from: date)
    description = descriptionString
  }
  
  convenience init(visit: CLVisit, descriptionString: String) {
    self.init(visit.coordinate, date: visit.arrivalDate, descriptionString: descriptionString)
  }
}

