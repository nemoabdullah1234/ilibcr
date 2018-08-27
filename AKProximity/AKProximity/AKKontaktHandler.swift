//
//  AKKontaktHandler.swift
//  AKProximity
//
//  Created by Nitin Singh on 12/07/17.
//  Copyright © 2017 OSSCube. All rights reserved.
//

import UIKit
import KontaktSDK


public protocol AKKontaktSDKLocationManagerDelegate{
    func akKontaktProximityManager(_ manager: AKKontaktHandler, didChangeAuthorizationStatus status: CLAuthorizationStatus);
    func akKontaktProximityManager(_ manager: AKKontaktHandler, didDetermineState state: CLRegionState, forRegion region: KTKBeaconRegion);
    func akKontaktProximityManager(_ manager: AKKontaktHandler, didEnterRegion region: KTKBeaconRegion);
    func akKontaktProximityManager(_ manager: AKKontaktHandler, didExitRegion region: KTKBeaconRegion) ;
    func akKontaktProximityManager(_ manager: AKKontaktHandler, didRangeBeacons beacons: [CLBeacon], inRegion region: KTKBeaconRegion);
}
public extension AKKontaktSDKLocationManagerDelegate{
    func akKontaktProximityManager(_ manager: AKKontaktHandler, didChangeAuthorizationStatus status: CLAuthorizationStatus){}
    func akKontaktProximityManager(_ manager: AKKontaktHandler, didDetermineState state: CLRegionState, forRegion region: KTKBeaconRegion){}
    func akKontaktProximityManager(_ manager: AKKontaktHandler, didEnterRegion region: KTKBeaconRegion){}
    func nbProximityManager(_ manager: AKKontaktHandler, didExitRegion region: KTKBeaconRegion) {}
    func akKontaktProximityManager(_ manager: AKKontaktHandler, didRangeBeacons beacons: [CLBeacon], inRegion region: KTKBeaconRegion){}
}



open class AKKontaktHandler: NSObject {
    fileprivate var locationManager :CLLocationManager!
    var beaconManager: KTKBeaconManager!
    open var delegate: AKKontaktSDKLocationManagerDelegate?
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager();
        beaconManager = KTKBeaconManager(delegate: self)
        self.locationManager.requestAlwaysAuthorization()
        
    }
    open func akKontaktRequestAlwaysAuthorization(){
        
        beaconManager.requestLocationAlwaysAuthorization()
        
    }
    open func akKontaktStopRangingBeaconsInRegion(_ region:KTKBeaconRegion!){
        
        beaconManager.stopRangingBeacons(in: region)
        
    }
    open func akKontaktStartRangingBeaconsInRegion(_ region:KTKBeaconRegion!){
        beaconManager.startRangingBeacons(in: region)
    }
    open class func akKontaktLocationServicesEnabled()->Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    open func akKontaktStartMonitoringForRegion(_ region:KTKBeaconRegion!){
        beaconManager.startMonitoring(for: region)
    }
    open class func akKontaktIsMonitoringAvailableForClass(_ regionClass:AnyClass)->Bool{
        return CLLocationManager.isMonitoringAvailable(for: regionClass)
    }
    open class func akKontaktAuthorizationStatus()->CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
}


extension AKKontaktHandler: KTKBeaconManagerDelegate {
    
    public func beaconManager(_ manager: KTKBeaconManager, didChangeLocationAuthorizationStatus status: CLAuthorizationStatus){
        self.delegate?.akKontaktProximityManager(self, didChangeAuthorizationStatus:status)
    }
    
    public func beaconManager(_ manager: KTKBeaconManager, didDetermineState state: CLRegionState, for region: KTKBeaconRegion){
        self.delegate?.akKontaktProximityManager(self, didDetermineState: state, forRegion: region)
    }
    
    public func beaconManager(_ manager: KTKBeaconManager, monitoringDidFailFor region: KTKBeaconRegion?, withError error: Error?) {
        // print("Monitoring did fail for region: \(region)")
        //print("Error: \(error)")
    }
    
    public func beaconManager(_ manager: KTKBeaconManager, didStartMonitoringFor region: KTKBeaconRegion) {
        //print("Did start monitoring for region: \(region)")
    }
    
   public func beaconManager(_ manager: KTKBeaconManager, didEnter region: KTKBeaconRegion) {
        self.delegate?.akKontaktProximityManager(self, didEnterRegion: region)
    }
    
   public func beaconManager(_ manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
    // print("Did exit region \(region)")
     self.delegate?.akKontaktProximityManager(self, didExitRegion: region)
    }
    
    
   public func beaconManager(_ manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], in region: KTKBeaconRegion) {

    
     self.delegate?.akKontaktProximityManager(self, didRangeBeacons: beacons, inRegion: region)
    
    }
    
}
