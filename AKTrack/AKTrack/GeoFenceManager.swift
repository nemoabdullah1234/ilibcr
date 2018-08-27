//
//  GeoFenceManager.swift
//  AKTrack
//
//  Created by Amarendra on 11/20/17.
//  Copyright © 2017 Akwa. All rights reserved.
//

import UIKit
import CoreLocation
protocol  GeoFenceManagerDelegate{
    func geofencemanagerDidFilter(geofences:[CLCircularRegion])
}

class GeoFenceManager: NSObject {
    var delegate:GeoFenceManagerDelegate?
    var arr = [CLCircularRegion]()
    func filterLocations(locations:[GeoFence] ,currentCoord:CLLocation){
        DispatchQueue.global().async {
            let   arrcpy = locations.sorted(by: { (a, b) -> Bool in
                return a.distance(from: currentCoord) < b.distance(from: currentCoord)
            })
            for (i,location) in arrcpy.enumerated(){
                if(i > 17){break}
                let region = CLCircularRegion.init(center: location.center, radius: 200, identifier: location.identifier)
                region.notifyOnExit = true
                region.notifyOnEntry = true
                self.arr.append(region)
            }
            DispatchQueue.main.async {
                self.delegate?.geofencemanagerDidFilter(geofences: self.arr)
            }
        }
    }
}
