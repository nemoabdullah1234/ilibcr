

import UIKit

@objc public class  AKSyncStateModel:NSObject{
    public var UDIDBeacon: String = ""
    public  var major:String = ""
    public  var minor:String = ""
    public var lattitude:String = ""
    public  var longitude:String = ""
    public  var proximity:String = ""
}

@objc public class AKSyncState: NSObject {
    fileprivate var arrayOfSensorData:Array<AKSyncStateModel> = Array<AKSyncStateModel>()
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
    
    open var setRole :String = ""
    
    public static let sharedHandler: AKSyncState =  AKSyncState()
    var concurrentApplicationStateQueue: DispatchQueue?
    override init() {
        super.init()
        concurrentApplicationStateQueue = DispatchQueue(label: "com.nicbit.applicationstatequeue", attributes: DispatchQueue.Attributes.concurrent)
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    //Setters
    public func setSensorData(_ sensor:AKSyncStateModel)
    {
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.arrayOfSensorData.append(sensor)
        })
         self.logEvent()
    }
    public func setBLEAvailable(_ bleState:String){
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
    public func setGPSAvailable(_ gpsState:String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.GPSAvailable = gpsState
            
        })
        self.logEvent()
    }
    public func setWIFIAvailable(_ wifiState:String){
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
    public func clearSensorData()
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
    public func setDeivceid(_ deivceid :String){
        self.concurrentApplicationStateQueue!.async(flags: .barrier, execute: {
            self.deviceID = deivceid
        })
    }
    
    
    //getters
    public func getRecordTime()-> String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str =  self.recordTime
        }
        return ((str! == "") ?"NA":str!)
    }
    
    public func getSensorData()->Array<AKSyncStateModel>
    {
        var array: Array<AKSyncStateModel>?
        self.concurrentApplicationStateQueue!.sync {
            array = self.arrayOfSensorData
            
        }
        return array!
    }
    public func getBLEAvailable()-> String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str =  self.BLEAvailable
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getDeviceid()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.deviceID
        }
        return ((str! == "") ?"NA":str!)
    }
    
    public func getGPSAvailable()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.GPSAvailable
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getWIFIAvailable()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.WIFIAvailable
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getAltitude()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.altitude
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getDirection()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.direction
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getSpeed()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.speed
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getAccuracy()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = self.accuracy
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getApiHitTime()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = apiHitTime
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getLogTime()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = logTime
        }
        return ((str! == "") ?"NA":str!)
    }
    public func getBatteryState()->String{
        var str: String?
        self.concurrentApplicationStateQueue!.sync {
            str = "\(UIDevice.current.batteryLevel*100)"//batteryState
        }
        return ((str! == "") ?"NA":str!)
    }
    public func formatDate(_ epoch:String)-> String{
        if(epoch == "" || epoch == "NA")
        {
            return ""
        }
        let str =  epoch.substring(with: epoch.characters.index(epoch.startIndex, offsetBy: 0)..<epoch.characters.index(epoch.startIndex, offsetBy: 10))
        let epc = NSString(string: str).doubleValue
        let date =  Date.init(timeIntervalSince1970:epc)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy  HH:mm:ss"
        let timeStamp = formatter.string(from: date)
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
    
    
   /* public func logEvent()
    {
        
        
        
        let sensors:Array<AKSyncStateModel> = getSensorData()
        var str = "UUID,Major,Minor,Range,Lat,Long,Accuracy,Speed,Alt,Direction,Time_record,APIHit_time,Log_time,Battery,BLE,GPS,WIFI,PKID, Code"
        if sensors.count > 0{
            for (_,obj) in sensors.enumerated(){
                str =   str.replacingOccurrences(of: "UUID", with: obj.UDIDBeacon)
                str =   str.replacingOccurrences(of: "Major", with: obj.major)
                str =   str.replacingOccurrences(of: "Minor", with: obj.minor)
                str =    str.replacingOccurrences(of: "Range", with: obj.proximity)
                str =   str.replacingOccurrences(of: "Lat", with: obj.lattitude)
                str =   str.replacingOccurrences(of: "Long", with: obj.longitude)
                str =    str.replacingOccurrences(of: "Accuracy", with: getAccuracy())
                str =    str.replacingOccurrences(of: "Speed", with: getSpeed())
                str =    str.replacingOccurrences(of: "Alt", with: getAltitude())
                str =    str.replacingOccurrences(of: "Direction", with: getDirection())
                str =   str.replacingOccurrences(of: "Time_record", with: formatDate(getRecordTime()))
                str =    str.replacingOccurrences(of: "APIHit_time", with: getApiHitTime())
                str =    str.replacingOccurrences(of: "Log_time", with:getLogTime())
                str =    str.replacingOccurrences(of: "Battery", with: getBatteryState())
                str =    str.replacingOccurrences(of: "BLE", with: getBLEAvailable())
                str =    str.replacingOccurrences(of: "GPS", with: getGPSAvailable())
                str =    str.replacingOccurrences(of: "WIFI", with: getWIFIAvailable())
                str =    str.replacingOccurrences(of: "PKID", with: getDeviceid() + "\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))")
                str =    str.replacingOccurrences(of: "Code", with: getDeviceid())
                
                
            }
            createLog(str)
        }
        else{
            str =   str.replacingOccurrences(of: "UUID", with:"")
            str =   str.replacingOccurrences(of: "Major", with:"")
            str =   str.replacingOccurrences(of: "Minor", with: "")
            str =    str.replacingOccurrences(of: "Range", with: "")
            str =   str.replacingOccurrences(of: "Lat", with: "")
            str =   str.replacingOccurrences(of: "Long", with:"")
            str =    str.replacingOccurrences(of: "Accuracy", with: getAccuracy())
            str =    str.replacingOccurrences(of: "Speed", with: getSpeed())
            str =    str.replacingOccurrences(of: "Alt", with: getAltitude())
            str =    str.replacingOccurrences(of: "Direction", with: getDirection())
            str =   str.replacingOccurrences(of: "Time_record", with:formatDate(getRecordTime()))
            str =    str.replacingOccurrences(of: "APIHit_time", with: getApiHitTime())
            str =    str.replacingOccurrences(of: "Log_time", with:getLogTime())
            str =    str.replacingOccurrences(of: "Battery", with: getBatteryState())
            str =    str.replacingOccurrences(of: "BLE", with: getBLEAvailable())
            str =    str.replacingOccurrences(of: "GPS", with: getGPSAvailable())
            str =    str.replacingOccurrences(of: "WIFI", with: getWIFIAvailable())
            str =    str.replacingOccurrences(of: "PKID", with: getDeviceid() + "\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))")
            str =    str.replacingOccurrences(of: "Code", with: getDeviceid())
            
            
        }
        createLog(str)
        
    }
    
    public func createLog(_ str:String){
        let  strCopy = str + "\n\n"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("/"+setRole+"_log.csv").path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("FILE AVAILABLE")
            let fileHandle = FileHandle(forWritingAtPath: filePath)
            fileHandle!.seekToEndOfFile()
            let data = strCopy.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            fileHandle!.write(data)
            fileHandle!.closeFile()
        } else {
            print("FILE NOT AVAILABLE")
            let str = "UUID,Major,Minor,Range,Lat,Long,Accuracy,Speed,Alt,Direction,Time_record,APIHit_time,Log_time,Battery,BLE,GPS,WIFI,PKID,Code\n\n\n" + strCopy
            try! str.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        }
        
    }*/
    open func logEvent()
    {
        /*
        let sensors:Array<AKSyncStateModel> = getSensorData()
        // UUID	Maj	Min	Rng	Lat	Lon	Acc	Spd	Alt	Dir	ts(ISO)	prv Localts MQTTts(ISO)	Logts(ISO)	Batt BLE GPS WIFI	Pkid	Code
        
        
        var str = "UUID,Maj,Min,Rng,Lat,Lon,Acc,Spd,Alt,Dir,ts,prv,Localts,MQTTts,Logts,Batt,BLE,GPS,WIFI,Pkid, Code"
        if sensors.count > 0{
            for (_,obj) in sensors.enumerated(){
                str =   str.replacingOccurrences(of: "UUID", with: obj.UDIDBeacon)
                str =   str.replacingOccurrences(of: "Maj", with: obj.major)
                str =   str.replacingOccurrences(of: "Min", with: obj.minor)
                str =    str.replacingOccurrences(of: "Rng", with: obj.proximity)
                str =   str.replacingOccurrences(of: "Lat", with: obj.lattitude)
                str =   str.replacingOccurrences(of: "Lon", with: obj.longitude)
                str =    str.replacingOccurrences(of: "Acc", with: getAccuracy())
                str =    str.replacingOccurrences(of: "Spd", with: getSpeed())
                str =    str.replacingOccurrences(of: "Alt", with: getAltitude())
                str =    str.replacingOccurrences(of: "Dir", with: getDirection())
                str =    str.replacingOccurrences(of: "prv", with: "NA")
                str =    str.replacingOccurrences(of: "Localts", with: formatDate(getRecordTime()))
                str =    str.replacingOccurrences(of: "MQTTts", with: getApiHitTime())
                str =    str.replacingOccurrences(of: "Logts", with:getLogTime())
                str =    str.replacingOccurrences(of: "ts", with: getRecordTime())
                str =    str.replacingOccurrences(of: "Batt", with: getBatteryState())
                str =    str.replacingOccurrences(of: "BLE", with: getBLEAvailable())
                str =    str.replacingOccurrences(of: "GPS", with: getGPSAvailable())
                str =    str.replacingOccurrences(of: "WIFI", with: getWIFIAvailable())
                str =    str.replacingOccurrences(of: "Pkid", with: getDeviceid() + getRecordTime())//"\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))"
                str =    str.replacingOccurrences(of: "Code", with:  getDeviceid())
                
            }
            // createLog(str)
        }
        else{
            str =   str.replacingOccurrences(of: "UUID", with:"NA")
            str =   str.replacingOccurrences(of: "Maj", with:"NA")
            str =   str.replacingOccurrences(of: "Min", with: "NA")
            str =    str.replacingOccurrences(of: "Rng", with: "NA")
            str =   str.replacingOccurrences(of: "Lat", with: "NA")
            str =   str.replacingOccurrences(of: "Lon", with:"NA")
            str =    str.replacingOccurrences(of: "Acc", with: getAccuracy())
            str =    str.replacingOccurrences(of: "Spd", with: getSpeed())
            str =    str.replacingOccurrences(of: "Alt", with: getAltitude())
            str =    str.replacingOccurrences(of: "Dir", with: getDirection())
            str =    str.replacingOccurrences(of: "prv", with: "NA")
            str =    str.replacingOccurrences(of: "Localts", with: formatDate(getRecordTime()))
            str =    str.replacingOccurrences(of: "MQTTts", with: getApiHitTime())
            str =    str.replacingOccurrences(of: "Logts", with:getLogTime())
            str =   str.replacingOccurrences(of: "ts", with:getRecordTime())
            str =    str.replacingOccurrences(of: "Batt", with: getBatteryState())
            str =    str.replacingOccurrences(of: "BLE", with: getBLEAvailable())
            str =    str.replacingOccurrences(of: "GPS", with: getGPSAvailable())
            str =    str.replacingOccurrences(of: "WIFI", with: getWIFIAvailable())
            str =    str.replacingOccurrences(of: "Pkid", with: getDeviceid() + getRecordTime())//"\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))"
            str =    str.replacingOccurrences(of: "Code", with:  getDeviceid())
            
        }
        //  createLog(str)*/
        
    }
    
    open  func createLog(_ str:String){
        let deviceId  =  self.getDeviceid()
        if(deviceId == "NA" || deviceId == "")
        {
            return
        }
        let dateForFileName = self.formatDateForFileName()
        
        
        let fileName = setRole + "_" + dateForFileName + "_" + deviceId 
        let  strCopy = str + "\n\n"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        //SR_yyyymondd_<deviceid>.csv
        let filePath = url.appendingPathComponent("/" + fileName + ".csv").path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("FILE AVAILABLE ---  sync")
            let fileHandle = FileHandle(forWritingAtPath: filePath)
            fileHandle!.seekToEndOfFile()
            let data = strCopy.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            fileHandle!.write(data)
            fileHandle!.closeFile()
        } else {
            print("FILE NOT AVAILABLE ---- sync")
            let str = "UUID,Maj,Min,Rng,Lat,Lon,Acc,Spd,Alt,Dir,ts,prv,Localts,MQTTts,Logts,Batt,BLE,GPS,WIFI,Pkid, Code\n\n\n" + strCopy
            try! str.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        }
        
    }

    
}
