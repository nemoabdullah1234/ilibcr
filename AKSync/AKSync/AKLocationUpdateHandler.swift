

import UIKit
import RealmSwift
import CoreBluetooth
import CoreLocation



@objc public class AKLocationUpdateHandler: NSObject {
    open  static let sharedHandler:AKLocationUpdateHandler = AKLocationUpdateHandler()
    open var delegate: AKLocationUpdaterDelegate?
    
    var timer: Timer?
    var sendInterval = 300.00
    var locationUpdateTimer: Timer?
    open var Kbase_url : String = ""
    open var saveFactor = 0.0
    open var setRole = ""
    
    
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AKLocationUpdateHandler.handleBackground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil);
        
        _ = AKUtility()
        
        
        
        if (AKUtility.getUserRole() ==  "warehouse") {
            
            applicationEnvironment.ApplicationCurrentType = applicationType.warehouseOwner
        }else{
            
            applicationEnvironment.ApplicationCurrentType = applicationType.salesRep
        }
        
    }
    
    public func setBaseUrl(_ baseUrl : String) {
        AKUtility.setBaseUrl(baseUrl)
        
        print(AKUtility.getBaseUrl())
        
    }
    
    
    public func setRole(_ role : String) {
        AKUtility.setUserRole(role)
        
        print(AKUtility.getUserRole())
        
    }
    
    
    //    public func setAKSyncObject(objectModel : Object.Type) {
    //
    //        syncObject = objectModel
    //
    //        print(syncObject.description)
    //
    //    }
    
    
    
    @objc public func handleBackground(){
        self.AKSyncXtimeNew()
    }
    public func AKStopSync()->(){
        self.locationUpdateTimer?.invalidate()
        self.locationUpdateTimer = nil
    }
    
    public func AKInitiateTimer(){
        if(self.locationUpdateTimer == nil)
        {
            let time:TimeInterval = 60.0;
            self.locationUpdateTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector:#selector(AKLocationUpdateHandler.updateLocation), userInfo: nil, repeats: true)
        }
    }
    
    @objc public func updateLocation() {
        self.AKSyncXtimeNew()
    }
    
    public func AKIntiateSyncSequence() -> () {
        if(self.timer == nil)
        {
            self.timer = Timer.scheduledTimer(timeInterval: (self.sendInterval+saveFactor),
                                              target: self,
                                              selector: #selector(AKLocationUpdateHandler.tick),
                                              userInfo: nil,
                                              repeats: true)//
        }
        
    }
    
    var array = [Dictionary<String,String>]()
    
    
    @objc public func tick() ->()  {
        //  BeaconHandler.sharedHandler.PKSyncObj = "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000.0)))"
        self.AKSyncXtimeNew()
    }
    
}

extension AKLocationUpdateHandler
{
    public func AKSyncXtimeNew() -> () {
        
        
        let realm = try! Realm()
        // Utility.showNotification("sync called", message: "Location sync")
        print("sync called")
        var array = [Dictionary<String,AnyObject>]()
        let dataLIst = realm.objects(AKSyncObject.self).filter("synced = false")
        // let dataLIst = realm.dynamicObjects("OSSSyncObject").filter("synced = false")
        print("datalist called    \(dataLIst)")
        var devToken = AKUtility.getDevice()
        var projectId = AKUtility.getProjectId()
        var clientId = AKUtility.getClientId()
        
        if(devToken == nil)
        {
            devToken = " "
        }
        
        
        var count = 0
        if(dataLIst.count<=500)
        {
            if(dataLIst.count  == 0)
            {
                
                
                delegate?.AKSetLogData("1")
                
                return
            }
            else
            {
                print("datalist count <= 0 ")
                count = dataLIst.count - 1
            }
        }
        else{
            count = 500
        }
        for i in 0...count{
            let syncObj :AKSyncObject = dataLIst[i]
            var loc = Dictionary<String,AnyObject>()
            
            print("It's for Sales Rep")
            loc["projectid"] = projectId as AnyObject
            loc["clientid"] = clientId as AnyObject
            loc["did"] = devToken as AnyObject
            loc["lat"] = Double(syncObj.value(forKey: "lat") as! String) as AnyObject
            loc["lon"] = Double(syncObj.value(forKey: "lng") as! String) as AnyObject
            loc["ts"] =  Double(syncObj.value(forKey: "id") as! String) as AnyObject
            loc["alt"] = Double(syncObj.value(forKey: "alt") as! String) as AnyObject
            loc["spd"] = Double(syncObj.value(forKey: "speed") as! String) as AnyObject
            loc["dir"] = Double(syncObj.value(forKey: "direction") as! String) as AnyObject
            loc["acc"] = Double(syncObj.value(forKey: "accuracy") as! String) as AnyObject
            loc["prv"] = "\(syncObj.value(forKey: "provider") as! String)" as AnyObject
            loc["pkid"] = "\(syncObj.value(forKey: "pkid") as! String)" as AnyObject
            loc["ht"] = (Int64(floor(Date().timeIntervalSince1970 * 1000.0))) as AnyObject
            
            var sens = [Dictionary<String,AnyObject>]()
            for becn in syncObj.event{
                var sensor = Dictionary<String,AnyObject>()
                
                let state = AKSyncStateModel()
                state.major = becn.value(forKey: "major") as! String
                state.minor = becn.value(forKey: "minor") as! String
                state.proximity = becn.value(forKey: "proximity") as! String
                state.longitude = syncObj.value(forKey: "lng") as! String
                state.lattitude = syncObj.value(forKey: "lat") as! String
                state.UDIDBeacon = becn.value(forKey: "uuid") as! String
                AKSyncState.sharedHandler.setRole = setRole
                AKSyncState.sharedHandler.setSensorData(state)
                delegate?.AKSetLogData("2")
                // delegate?.AKSenserData(state)
                
                sensor["uuid"] = becn.value(forKey: "uuid") as? String as AnyObject
                sensor["maj"] = NSInteger((becn.value(forKey: "major") as? String)!) as AnyObject
                sensor["min"] = NSInteger((becn.value(forKey: "minor") as? String)!) as AnyObject
                sensor["rng"] = Double((becn.value(forKey: "proximity") as? String)!) as AnyObject
                sensor["rssi"] = NSInteger((becn.value(forKey: "rssi") as? String)!) as AnyObject
                sensor["dis"] = Double((becn.value(forKey: "distance") as? String)!) as AnyObject
                sensor["type"] = "beacon" as AnyObject
                sens.append(sensor)
                
            }
            loc["sensors"] =  sens as AnyObject
            array.append(loc)
            
        }
        
        
        
        if(array.count == 0)
        {
            print("aborted usless sync")
            delegate?.AKSetLogData("1")
            AKSyncState.sharedHandler.setRole = setRole
            AKSyncState.sharedHandler.setApiHitTime("\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))")
            AKSyncState.sharedHandler.logEvent()
            AKSyncState.sharedHandler.setApiHitTime("")
            
            return
        }
        let api = AKGeneralAPI()
        
        print("track api hit")
        
        
        var param = Dictionary<String,AnyObject>()
        param.updateValue(array as AnyObject, forKey: "beacons")
        delegate?.AKSetLogData("4")
        AKSyncState.sharedHandler.setRole = setRole
        AKSyncState.sharedHandler.setApiHitTime("\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))")
        AKSyncState.sharedHandler.logEvent()
        AKSyncState.sharedHandler.setApiHitTime("")
        delegate?.AKSendJsonToMQTT(param)
        self.delegate?.AKSetLogData("5")

        /* api.hitApiwith(param, serviceType:.strApiSyncNew, success: { (dict) in
         print (dict)
         DispatchQueue.main.async {
         self.delegate?.AKSetLogData("5")
         AKSyncState.sharedHandler.setRole = self.setRole
         AKSyncState.sharedHandler.clearSensorData()
         AKSyncState.sharedHandler.logEvent()
         try! realm.write({
         
         
         for obj  in dataLIst{
         obj.synced = true
         }
         
         //  for i in 0...count{
         //    let syncObj:OSSSyncObject = dataLIst[i]
         //      syncObj.synced = true
         // }
         //dataLIst.setValue("true", forKey: "synced")
         })
         }
         
         }) { (err) in
         print(err)
         DispatchQueue.main.async {
         self.delegate?.AKSetLogData("5")
         AKSyncState.sharedHandler.setRole = self.setRole
         AKSyncState.sharedHandler.logEvent()
         AKSyncState.sharedHandler.clearSensorData()
         }
         } */
        
    }
    
    public  func AKScannerstate()->(){
        
        
        var locationStatus : NSInteger
        var bluetoothStatus : NSInteger
        let os = "ios"
        let generalApi = AKGeneralAPI()
        
        
        bluetoothStatus =  AKUtility.getBlueToothState()
        if(!CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways)
        {
            locationStatus = 0
            AKSyncState.sharedHandler.setRecordTime("\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))")
            AKSyncState.sharedHandler.setGPSAvailable("0")
            self.delegate?.AKGPSState("0")
        }
        else{
            locationStatus = 1
            AKSyncState.sharedHandler.setRecordTime("\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))")
            AKSyncState.sharedHandler.setGPSAvailable("1")
            self.delegate?.AKGPSState("1")
            
        }
        
        let device = UIDevice.current;
        let currentDeviceId = device.identifierForVendor!.uuidString;
        
        generalApi.hitApiwith(["deviceId":currentDeviceId as AnyObject,"appCode" : AKUtility.getDevice() as AnyObject, "locationStatus":locationStatus as AnyObject,"bluetoothStatus":bluetoothStatus as AnyObject,"os":os as AnyObject], serviceType: .strApiStatus, success: { (response) in
            print(response)
        }) { (error) in
            
        }
        
        
    }
}


@objc public protocol AKLocationUpdaterDelegate{
     func AKSetLogData(_ datacount: String);
     func AKSenserData(_ senserDate: AKSyncStateModel);
     func AKGPSState(_ gpsState: String);
     func AKSendJsonToMQTT (_  jsonMQTT : Dictionary<String,AnyObject>)
    
}
public extension AKLocationUpdaterDelegate{
    func AKSetLogData(_ datacount: String){
    }
    func AKSenserData(_ senserDate: AKSyncStateModel){
    }
    func AKGPSState(_ gpsState: String){
        
    }
    func AKSendJsonToMQTT (_  jsonMQTT : Dictionary<String,AnyObject>)
    {
        
    }
}






