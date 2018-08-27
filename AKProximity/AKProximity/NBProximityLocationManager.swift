//
//  NBProximityLocationManager.swift
//  Stryker
//
//  Created by Amarendra on 3/27/17.
//  Copyright © 2017 OSSCube. All rights reserved.
//

import UIKit
import CoreLocation



public protocol NBProximityLocationManagerDelegate{
    func nbProximityManager(_ manager: NBProximityManager, didChangeAuthorizationStatus status: CLAuthorizationStatus);
    func nbProximityManager(_ manager: NBProximityManager, didDetermineState state: CLRegionState, forRegion region: CLRegion);
    func nbProximityManager(_ manager: NBProximityManager, didEnterRegion region: CLRegion);
    func nbProximityManager(_ manager: NBProximityManager, didExitRegion region: CLRegion) ;
    func nbProximityManager(_ manager: NBProximityManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion);
}
public extension NBProximityLocationManagerDelegate{
    func nbProximityManager(_ manager: NBProximityManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){}
    func nbProximityManager(_ manager: NBProximityManager, didDetermineState state: CLRegionState, forRegion region: CLRegion){}
    func nbProximityManager(_ manager: NBProximityManager, didEnterRegion region: CLRegion){}
    func nbProximityManager(_ manager: NBProximityManager, didExitRegion region: CLRegion) {}
    func nbProximityManager(_ manager: NBProximityManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion){}
}

open class NBProximityManager: NSObject ,CLLocationManagerDelegate{
    fileprivate var locationManager :CLLocationManager!
    open var delegate: NBProximityLocationManagerDelegate?
    fileprivate var _allowsBackgroundLocationUpdates: Bool!
   
       
    @available(iOS 9.0, *)
    open var allowsBackgroundLocationUpdates: Bool? {
        get {
            return _allowsBackgroundLocationUpdates
        }
        set {
            _allowsBackgroundLocationUpdates = newValue!
        }
    }
    public override init() {
    super.init()
        self.locationManager = CLLocationManager();
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        // Enable automatic pausing
        self.locationManager.pausesLocationUpdatesAutomatically = true
        
        // Specify the type of activity your app is currently performing
        self.locationManager.activityType = CLActivityType.fitness
        
        
        self.locationManager.delegate = self
        if #available(iOS 9.0, *) {
            self.locationManager.allowsBackgroundLocationUpdates = false
        } else {
            // Fallback on earlier versions
        }
        
    }
    open func nbRequestAlwaysAuthorization(){
        
            self.locationManager.requestAlwaysAuthorization()
        
    }
    open func nbStopRangingBeaconsInRegion(_ region:CLBeaconRegion!){
        
            self.locationManager.stopRangingBeacons(in: region)
       
    }
    open func nbStartRangingBeaconsInRegion(_ region:CLBeaconRegion!){
        self.locationManager.startRangingBeacons(in: region)
    }
    open class func nbLocationServicesEnabled()->Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    open func nbStartMonitoringForRegion(_ region:CLBeaconRegion!){
        self.locationManager.startMonitoring(for: region)
    }
    open class func nbIsMonitoringAvailableForClass(_ regionClass:AnyClass)->Bool{
    return CLLocationManager.isMonitoringAvailable(for: regionClass)
    }
    open class func nbAuthorizationStatus()->CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
}
extension NBProximityManager{
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        self.delegate?.nbProximityManager(self, didChangeAuthorizationStatus:status)
    }
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion){
        self.delegate?.nbProximityManager(self, didDetermineState: state, forRegion: region)
    }
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion){
        self.delegate?.nbProximityManager(self, didEnterRegion: region)
    }
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.delegate?.nbProximityManager(self,didExitRegion: region)
    }
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){
        self.delegate?.nbProximityManager(self,didRangeBeacons: beacons, inRegion: region )
    }

}
