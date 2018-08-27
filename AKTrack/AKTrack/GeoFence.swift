//
//  GeoFence.swift
//  AKTrack
//
//  Created by Amarendra on 11/20/17.
//  Copyright © 2017 Akwa. All rights reserved.
//

import UIKit
import CoreLocation
public class GeoFence: NSObject {
    var lat:Double
    var lng:Double
    var identifier:String
    var center:CLLocationCoordinate2D{return CLLocationCoordinate2D.init(latitude: lat, longitude: lng)}
    func distance(from location:CLLocation)->CLLocationDistance{
        let a = CLLocation.init(latitude: lat, longitude: lng)
        return a.distance(from:location)
    }
    public init(latitude:Double,longitude:Double,identifier:String) {
        self.lat = latitude
        self.lng = longitude
        self.identifier = identifier
        super.init()
    }
}
