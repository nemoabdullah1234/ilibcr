//
//  LocationTracker.swift
//  TrackingDemo
//
//  Created by Amarendra on 11/13/17.
//  Copyright © 2017 Akwa. All rights reserved.
//
/*
 *************Important***************
 
 Timer code has been commented and start and pause is being handeled using
 region awareness
 
 Speed Filter
 1.Minimum Speed after which to stop navigation  [Sample size 10 records]
 2.Time duration, after which to stop navigation
 3.Geofence (minimum 200 mtrs)
 Beacon Filter
 */
import UIKit
import CoreLocation
public protocol LocationTrackerDelegate{
    func updated(lat:Double,long:Double,speed:Double)
    func regionEvent(region:String)
}

public class LocationTracker: NSObject {
    var speedAltitude: ((String,String)->())?
    var locationAcuracy:((CLLocationCoordinate2D,String)->())?
    var headingBlock:((String)->())?
    var myLastLocation: CLLocationCoordinate2D?
    var myLastLocationAccuracy: CLLocationAccuracy?
    var myLocation: CLLocationCoordinate2D?
    var myLocationAccuracy: CLLocationAccuracy?
    var shareModel:LocationShareModel?
    open var trackingPath:Bool = false
    open var beaconUUDI:String?
    open var delegate:LocationTrackerDelegate?
    var geoFenceManager:GeoFenceManager?
    var arrayOfGeoFences:[GeoFence]?
    private static let _locationManager:CLLocationManager = CLLocationManager()
    open static let sharedTracker:LocationTracker = LocationTracker()
    class func sharedLocationManager()->(CLLocationManager){
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.allowsBackgroundLocationUpdates = true;
        _locationManager.pausesLocationUpdatesAutomatically = false;
        return _locationManager
    }
    deinit {
        print(self)
    }
    public override init() {
        self.shareModel = LocationShareModel.sharedModel
        self.geoFenceManager = GeoFenceManager()
        super.init()
        self.geoFenceManager?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(LocationTracker.applicationEnterBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        self.shareModel?.stateTimer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(LocationTracker.determineState), userInfo:nil, repeats: false)
    }
    
    @objc func applicationEnterBackground(){
        let locationManager = LocationTracker.sharedLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        self.shareModel?.bgTask = BackgroundTaskManager.sharedBackgroundTaskManager
        self.shareModel?.bgTask.beginNewBackgroundTask()
    }
    @objc func restartFromTimer(){
        restartLocationUpdates(identifierString: "from timer")
    }
    @objc func restartLocationUpdates(identifierString:String?){
        print("\(identifierString!)")
        self.disableTimer()
        let locationManager = LocationTracker.sharedLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        for (_,region) in locationManager.monitoredRegions.enumerated(){
            locationManager.requestState(for: region)
        }
    }
    public func startLocationTracking(speedAndAltitude:@escaping(String,String)->(),location locationBlock:@escaping(CLLocationCoordinate2D,String)->(),andHeading headingBlock:@escaping(String)->()){
        self.speedAltitude = speedAndAltitude
        self.locationAcuracy = locationBlock
        self.headingBlock = headingBlock
        
        if(!CLLocationManager.locationServicesEnabled())
        {
            //alert for location service disabled
        }
        else{
            let autherization =  CLLocationManager.authorizationStatus()
            switch autherization{
            case .restricted,.denied,.notDetermined:
                //alert not autherised
                print("not autherised")
            case .authorizedWhenInUse:
                //alert for when in use
                fallthrough
            case .authorizedAlways:
                let locationManager = LocationTracker.sharedLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                locationManager.distanceFilter = kCLDistanceFilterNone
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingHeading()
                locationManager.startUpdatingLocation()
            }
        }
    }
    public func setGeoFence(geofences:[GeoFence]){
        self.arrayOfGeoFences = geofences
    }
    func stopLocationTracking(callIdentifer:String){
        print("identifier:"+callIdentifer)
        self.disableTimer()
        let locationManager = LocationTracker.sharedLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 99999
        locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers
        locationManager.stopUpdatingHeading()
        locationManager.requestAlwaysAuthorization()
    }
    
    @objc func stopLocationDelayBy10Seconds(){
        let locationManager = LocationTracker.sharedLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 99999
        locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers
        locationManager.stopUpdatingHeading()
        locationManager.requestAlwaysAuthorization()
        if(self.locationAcuracy != nil && self.myLastLocation != nil){
            self.locationAcuracy?(self.myLastLocation!,"\(self.myLastLocationAccuracy ?? 0.0)")
        }
    }
    func startTimerBasedUpdates(){
        if((self.shareModel?.timer) != nil){
            return
        }
        self.shareModel?.bgTask = BackgroundTaskManager.sharedBackgroundTaskManager
        self.shareModel?.bgTask.beginNewBackgroundTask()
        
        self.shareModel?.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(LocationTracker.restartFromTimer), userInfo:nil, repeats: false)
        
        if(self.shareModel?.delay10Seconds != nil){
            self.shareModel?.delay10Seconds?.invalidate()
            self.shareModel?.delay10Seconds =  nil
        }
        self.shareModel?.delay10Seconds = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(LocationTracker.stopLocationDelayBy10Seconds), userInfo: nil, repeats: false)
    }
    func disableTimer(){
        if((self.shareModel?.timer) != nil){
            self.shareModel?.timer?.invalidate()
            self.shareModel?.timer = nil
        }
        if((self.shareModel?.delay10Seconds) != nil){
            self.shareModel?.delay10Seconds?.invalidate()
            self.shareModel?.delay10Seconds = nil
        }
    }
    open func initiateGeoFence(lat:Double,long:Double,identifier:String){
        let work = CLCircularRegion.init(center: CLLocationCoordinate2D.init(latitude:lat, longitude:long ), radius: CLLocationDistance.init(200), identifier:identifier)
        work.notifyOnExit = true
        work.notifyOnEntry = true
        let locationManager = LocationTracker.sharedLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoring(for: work)
    }
    public func initiateBeaconRegion(major:Int,minor:Int,uuid:String)
    {
        let beacon =  CLBeaconRegion.init(proximityUUID:UUID.init(uuidString: uuid)! , identifier: "BECON Region")
        //  let beacon = CLBeaconRegion.init(proximityUUID:UUID.init(uuidString: uuid)! , major: CLBeaconMajorValue(1), minor: CLBeaconMinorValue(65048), identifier: "BECON Region")
        beacon.notifyOnExit = true
        beacon.notifyOnEntry = true
        let locationManager = LocationTracker.sharedLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoring(for: beacon)
    }
    @objc func handleSlowSpeed(){
        self.geoFenceManager?.filterLocations(locations: self.arrayOfGeoFences!, currentCoord: CLLocation.init(latitude: (self.myLastLocation?.latitude)!, longitude:(self.myLastLocation?.longitude)! ))
       if (self.beaconUUDI != nil){self.initiateBeaconRegion(major: 0, minor: 0, uuid: self.beaconUUDI!)}
        self.shareModel?.speedTimer?.invalidate()
        self.shareModel?.speedTimer = nil
        self.shareModel?.speedTimerInactive = false
        self.initiateGeoFence(lat: (myLastLocation?.latitude)!, long: (myLastLocation?.longitude)!, identifier: "STOP_LOCATION")
        self.stopLocationTracking(callIdentifer: "handle slow speed")
    }
    @objc func determineState(){
        let locationManager = LocationTracker.sharedLocationManager()
        locationManager.delegate = self
        for (_,region) in locationManager.monitoredRegions.enumerated(){
            locationManager.requestState(for: region)
        }
    }
    
}

extension LocationTracker : CLLocationManagerDelegate{
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location update")
        for newLocation in locations{
            let theLocation = newLocation.coordinate
            let theAccuracy = newLocation.horizontalAccuracy
            let locationAge = newLocation.timestamp.timeIntervalSinceNow
            if(locationAge > 30)
            {
                continue
            }
            if(theAccuracy > 0 && theAccuracy < 200  && (!(theLocation.latitude==0.0 && theLocation.longitude==0.0))){
                self.myLastLocation = theLocation;
                self.myLastLocationAccuracy = theAccuracy;
                if(self.speedAltitude != nil)
                {
                    self.speedAltitude!("\(newLocation.speed)","\(newLocation.altitude)");
                }
                self.delegate?.updated(lat: theLocation.latitude, long:theLocation.longitude, speed: newLocation.speed)
                if !self.trackingPath{
                    if(self.locationAcuracy != nil){
                        self.locationAcuracy?(self.myLastLocation!,"\(self.myLastLocationAccuracy ?? 0.0)")
                    }
                }
                if(newLocation.speed <= 1 && !self.trackingPath){
                    if((self.shareModel?.speedTimer) == nil && (self.shareModel?.speedTimerInactive)!){
                        self.shareModel?.speedTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(LocationTracker.handleSlowSpeed), userInfo: nil, repeats: false)
                    }
                }
                else{
                    if((self.shareModel?.speedTimer) != nil){
                        self.shareModel?.speedTimer?.invalidate()
                        self.shareModel?.speedTimer = nil
                    }
                }
                if self.arrayOfGeoFences != nil && manager.monitoredRegions.count == 0{
                     self.geoFenceManager?.filterLocations(locations: self.arrayOfGeoFences!, currentCoord: CLLocation.init(latitude: (self.myLastLocation?.latitude)!, longitude:(self.myLastLocation?.longitude)! ))
                }
            }
        }
        if self.trackingPath{
            self.startTimerBasedUpdates()
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.headingBlock?("\(newHeading.magneticHeading)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if ((region as? CLCircularRegion) != nil){
            stopLocationTracking(callIdentifer: "did enter region")

            self.delegate?.regionEvent(region: "ENTER:"+region.identifier)
        }
        if((region as? CLBeaconRegion) != nil){
            let rgn  = region as! CLBeaconRegion
            self.delegate?.regionEvent(region: "ENTER:"+rgn.identifier + "\(rgn.major ?? 0)"+":"+"\(rgn.minor ?? 0)")
        }
        
    }
    
    public  func locationManager(_ manager: CLLocationManager,didExitRegion region: CLRegion) {
        if ((region as? CLCircularRegion) != nil){
            self.delegate?.regionEvent(region: "EXIT:"+region.identifier)
        }
        if((region as? CLBeaconRegion) != nil){
            let rgn  = region as! CLBeaconRegion
            self.delegate?.regionEvent(region: "EXIT:"+rgn.identifier + "\(rgn.major ?? 0)"+":"+"\(rgn.minor ?? 0)")
        }
        self.shareModel?.speedTimerInactive = true
        restartLocationUpdates(identifierString: ("called from exit region for" + region.identifier))
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside && (region as? CLCircularRegion != nil){
            stopLocationTracking(callIdentifer: "did determine state")
        }
    }
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways{
            let locationManager = LocationTracker.sharedLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
            if (self.beaconUUDI != nil){self.initiateBeaconRegion(major: 0, minor: 0, uuid: self.beaconUUDI!)}
        }
    }
}

extension LocationTracker : GeoFenceManagerDelegate{
    func geofencemanagerDidFilter(geofences:[CLCircularRegion]){
        for geo in geofences{
        let locationManager = LocationTracker.sharedLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoring(for: geo)
        }
    }
    
}
