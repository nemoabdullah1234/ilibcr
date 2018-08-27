//
//  AKApplicationState.swift
//  Nicbit
//
//  Created by Amarendra on 2/22/17.
//  Copyright © 2017 OSSCube. All rights reserved.
//

import UIKit
@objc open class AKSensorStateModel:NSObject{
    public var UDIDBeacon: String = ""
    public  var major:String = ""
    public  var minor:String = ""
    public var lattitude:String = ""
    public  var longitude:String = ""
    public  var proximity:String = ""
    public var type : String = ""
}
@objc open class AKApplicationState: NSObject {
    fileprivate var arrayOfSensorData:Array<AKSensorStateModel> = Array<AKSensorStateModel>()
    fileprivate var BLEAvailable:String = ""
    fileprivate var GPSAvailable:String = ""
    fileprivate var WIFIAvailable:String = ""
    fileprivate var altitude:String = ""
    fileprivate var direction:String = ""
    fileprivate var speed:String = ""
    fileprivate var accuracy:String = ""
    fileprivate var apiHitTime:String = ""
    fileprivate var logTime:String = ""
    fileprivate var batteryState:String = ""
    fileprivate var recordTime:String = ""
    fileprivate var deviceID:String = ""
    fileprivate var ack:String = ""
    
    open var setRole: String = ""
    open static let sharedHandler: AKApplicationState =  AKApplicationState()
    var concurrentApplicationStateQueue: DispatchQueue?
    override init() {
        super.init()
        concurrentApplicationStateQueue = DispatchQueue(label: "com.akwa.applicationstatequeue", attributes: DispatchQueue.Attributes.concurrent)
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    //Setters
    open func setSensorData(_ sensor:AKSensorStateModel)
    {
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.arrayOfSensorData.append(sensor)
        })
        // self.logEvent()
    }
    open func setBLEAvailable(_ bleState:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.BLEAvailable = bleState
        })
        self.logEvent()
    }
    public func setApiHitTime(_ apiHitTime:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.apiHitTime = apiHitTime//self.formatDate(apiHitTime)
        })
    }
    public func setLogTime(_ logTime:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.logTime = logTime//self.formatDate(logTime)
        })
    }
    public func setBatteryState(_ batteryState:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.batteryState = batteryState
        })
    }
    
    public func setDeivceid(_ deivceid :String){
        
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.deviceID = deivceid
            
        })
    }
    public func setACK(_ ack :String){
        
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.ack = ack
            
        })
    }
    
    open func setGPSAvailable(_ gpsState:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.GPSAvailable = gpsState
            
        })
        self.logEvent()
    }
    open func setWIFIAvailable(_ wifiState:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.WIFIAvailable = wifiState
        })
        self.logEvent()
    }
    public func setAltitude(_ altitude:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.altitude = altitude
        })
    }
    public func setDirection(_ direction:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.direction = direction
        })
    }
    public func setSpeed(_ speed: String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.speed =  speed
        })
    }
    public func setAccuracy(_ accuracy:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.accuracy = accuracy
        })
    }
    open func clearSensorData()
    {
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.arrayOfSensorData.removeAll()
        })
    }
    
    public func setRecordTime(_ time:String)
    {
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.recordTime = time
        })
    }
    
    
    //getters
    public func getRecordTime()-> String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str =  self.recordTime
        }
        return ((str! == "") ?"-99999":str!)
    }
    public func getSensorData()->Array<AKSensorStateModel>
    {
        var array: Array<AKSensorStateModel>?
        self.concurrentApplicationStateQueue!.sync {
            array = self.arrayOfSensorData
            
        }
        return array!
    }
    open func getBLEAvailable()-> String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str =  self.BLEAvailable
        }
        return ((str! == "") ?"-99999":str!)
    }
    
    open func getGPSAvailable()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.GPSAvailable
        }
        return ((str! == "") ?"-99999":str!)
    }
    open func getWIFIAvailable()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.WIFIAvailable
        }
        return ((str! == "") ?"-99999":str!)
    }
    public func getDeviceid()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.deviceID
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getACK()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.ack
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getAltitude()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.altitude
        }
        return ((str! == "" || Double(str!) == 0.0) ?"-99999":str!)
    }
    public func getDirection()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.direction
        }
        return ((str! == "") ?"-99999":str!)
    }
    public func getSpeed()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.speed
        }
        return ((str! == "" || str!.contains("-1")) ?"-99999":str!)
    }
    public func getAccuracy()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.accuracy
        }
        return ((str! == "") ?"-99999":str!)
    }
    public func getApiHitTime()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = apiHitTime
        }
        return ((str! == "") ?"-99999":str!)
    }
    public func getLogTime()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = logTime
        }
        return ((str! == "") ?"-99999":str!)
    }
    open func getBatteryState()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = "\(UIDevice.current.batteryLevel*100)"//batteryState
        }
        return ((str! == "") ?"-99999":str!)
    }
    public func formatDate(_ epoch:String)-> String{
        if(epoch == "" || epoch == "-99999")
        {
            return ""
        }
        let str =  epoch.substring(with: epoch.characters.index(epoch.startIndex, offsetBy: 0)..<epoch.characters.index(epoch.startIndex, offsetBy: 10))
        let epc = NSString(string: str).doubleValue
        let date =  Date.init(timeIntervalSince1970:epc)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy  HH:mm:ss"
        let timeStamp = formatter.string(from: date)
        //var tempInt :Int  = Int(timeStamp)!
        return timeStamp
    }
    public func formatDateForFileName()-> String{
        let epoch = "\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))"
        let str =  epoch.substring(with: epoch.characters.index(epoch.startIndex, offsetBy: 0)..<epoch.characters.index(epoch.startIndex, offsetBy: 10))
        let epc = NSString(string: str).doubleValue
        let date =  Date.init(timeIntervalSince1970:epc)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMMdd"
        let timeStamp = formatter.string(from: date)
        //var tempInt :Int  = Int(timeStamp)!
        return timeStamp
    }
    // function to switch on and off logging
    public func  enableLogs()->(Bool){
        var enabled = !UserDefaults.standard.bool(forKey: "LOG_ENABLE_AKLOG");
        UserDefaults.standard.set(enabled, forKey: "LOG_ENABLE_AKLOG")
        return enabled
      }
    public func getLoggingStatus()->(Bool){
        return UserDefaults.standard.bool(forKey: "LOG_ENABLE_AKLOG");
    }
    
    public func validateLatitude(lattitude:String) ->Bool
    {
        if let lat = Double(lattitude){
        if(lat < 90.0 && lat > -90.0)
        {
            return true
        }
        return false
        }
        else{
            return false
        }
    }
    public func validateLongitude(longitude:String) ->Bool
    {
        let lon = Double(longitude)!
        if(lon < 180.0 && lon > -180.0)
        {
            return true
        }
        return false
    }
    //Log Event
    
    open func logEvent()
    {
        let logEnabled = UserDefaults.standard.bool(forKey: "LOG_ENABLE_AKLOG");
        if(logEnabled == true)
        {
            return
        }
        
        let sensors:Array<AKSensorStateModel> = getSensorData()
        // UUID	Maj	Min	Rng	Lat	Lon	Acc	Spd	Alt	Dir	ts(ISO)	prv Localts MQTTts(ISO)	Logts(ISO)	Batt BLE GPS WIFI	Pkid	Code
        

        if sensors.count > 0{
            for (_,obj) in sensors.enumerated(){
                
               var str = "UUID,Maj,Min,Rng,Lat,Lon,Acc,Spd,Alt,Dir,ts,Localts,MQTTts,Logts,Batt,BLE,GPS,WIFI,Pkid,Code,ACK,Message  "
                
                str =   str.replacingOccurrences(of: "UUID", with: obj.UDIDBeacon)
                str =   str.replacingOccurrences(of: "Maj", with: obj.major)
                str =   str.replacingOccurrences(of: "Min", with: obj.minor)
                str =    str.replacingOccurrences(of: "Rng", with: obj.proximity)
                str =   str.replacingOccurrences(of: "Lat", with: validateLatitude(lattitude: obj.lattitude) ?"-99999":obj.lattitude)
                str =   str.replacingOccurrences(of: "Lon", with: (validateLongitude(longitude: obj.longitude) ?"-99999":obj.longitude))
                str =    str.replacingOccurrences(of: "Acc", with: getAccuracy())
                str =    str.replacingOccurrences(of: "Spd", with: getSpeed())
                str =    str.replacingOccurrences(of: "Alt", with: getAltitude())
                str =    str.replacingOccurrences(of: "Dir", with: getDirection())
                str =    str.replacingOccurrences(of: "Message", with: "NA")
                str =    str.replacingOccurrences(of: "Localts", with: formatDate(getRecordTime()))
                str =    str.replacingOccurrences(of: "MQTTts", with: getApiHitTime())
                str =    str.replacingOccurrences(of: "Logts", with:"\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))")//getLogTime()
                str =    str.replacingOccurrences(of: "ts", with: getRecordTime())
                str =    str.replacingOccurrences(of: "Batt", with: getBatteryState())
                str =    str.replacingOccurrences(of: "BLE", with: getBLEAvailable())
                str =    str.replacingOccurrences(of: "GPS", with: getGPSAvailable())
                str =    str.replacingOccurrences(of: "WIFI", with: getWIFIAvailable())
                str =    str.replacingOccurrences(of: "Pkid", with: getDeviceid() + getRecordTime())//"\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))"
                str =    str.replacingOccurrences(of: "Code", with:  getDeviceid())
                str =    str.replacingOccurrences(of: "ACK", with:  getACK())
                createLog(str)
            }
           
        }
        else{
            //UUID    Maj    Min    Rng    Lat    Lon    Acc    Spd    Alt    Dir    ts    Localts    MQTTts    Logts    Batt    BLE    GPS    WIFI    Pkid    Code    ACK    Message
            var str = "UUID,Maj,Min,Rng,Lat,Lon,Acc,Spd,Alt,Dir,ts,Localts,MQTTts,Logts,Batt,BLE,GPS,WIFI,Pkid,Code,ACK,Message  "

            str =   str.replacingOccurrences(of: "UUID", with:"NA")
            str =   str.replacingOccurrences(of: "Maj", with:"-99999")
            str =   str.replacingOccurrences(of: "Min", with: "-99999")
            str =    str.replacingOccurrences(of: "Rng", with: "-99999")
            str =   str.replacingOccurrences(of: "Lat", with: "-99999")
            str =   str.replacingOccurrences(of: "Lon", with:"-99999")
            str =    str.replacingOccurrences(of: "Acc", with: getAccuracy())
            str =    str.replacingOccurrences(of: "Spd", with: getSpeed())
            str =    str.replacingOccurrences(of: "Alt", with: getAltitude())
            str =    str.replacingOccurrences(of: "Dir", with: getDirection())
            str =    str.replacingOccurrences(of: "Message", with: "NA")
            str =    str.replacingOccurrences(of: "Localts", with: formatDate(getRecordTime()))
            str =    str.replacingOccurrences(of: "MQTTts", with: getApiHitTime())
            str =    str.replacingOccurrences(of: "Logts", with:"\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))")//getLogTime()
            str =   str.replacingOccurrences(of: "ts", with:getRecordTime())
            str =    str.replacingOccurrences(of: "Batt", with: getBatteryState())
            str =    str.replacingOccurrences(of: "BLE", with: getBLEAvailable())
            str =    str.replacingOccurrences(of: "GPS", with: getGPSAvailable())
            str =    str.replacingOccurrences(of: "WIFI", with: getWIFIAvailable())
            str =    str.replacingOccurrences(of: "Pkid", with: getDeviceid() + getRecordTime())//"\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))"
            str =    str.replacingOccurrences(of: "Code", with:  getDeviceid())
            str =    str.replacingOccurrences(of: "ACK", with:  getACK())
                createLog(str)

            
        }
        
        
    }
    
    open  func createLog(_ str:String){
        
        let deviceId  =  self.getDeviceid()
        if(deviceId == "NA" || deviceId == "")
        {
            return
        }
        let dateForFileName = self.formatDateForFileName()
        let fileName = setRole + "_" + dateForFileName + "_" + deviceId
        let  strCopy = str + "\n"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        //SR_yyyymondd_<deviceid>.csv
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
                   let filePath = url.appendingPathComponent("/" + fileName + ".csv").path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            let fileHandle = FileHandle(forWritingAtPath: filePath)
            fileHandle!.seekToEndOfFile()
            let data = strCopy.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            fileHandle!.write(data)
            fileHandle!.closeFile()
        } else {
            let str = "UUID,Maj,Min,Rng,Lat,Lon,Acc,Spd,Alt,Dir,ts,Localts,MQTTts,Logts,Batt,BLE,GPS,WIFI,Pkid,Code,ACK,Message  \n" + strCopy
            try! str.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        }
        })

    }
    
}
