//
//  Utility.swift
//  AKSync
//
//  Created by Nitin Singh on 24/03/17.
//  Copyright © 2017 NicBit. All rights reserved.
//

import Foundation


//let Kbase_url =  "http://strykerapi.nicbitqc.ossclients.com" //"https://strykerapi.nicbitqc.com" //"http://strykerapi.nicbit.ossclients.com"  //


enum applicationType {
    case salesRep, warehouseOwner
}


struct applicationEnvironment {
    static var ApplicationCurrentType = applicationType.salesRep
}



@objc class AKUtility: NSObject {
    class func getBlueToothState()->(Int){
        let state = UserDefaults.standard.value(forKey: "USERDEFAULTBLUETOOTH") as? Int
        if(state == nil)
        {
            return 0
        }
        return state!
    }
    class func setBlueToothState(_ state:Int)->(){
        UserDefaults.standard.set(state, forKey: "USERDEFAULTBLUETOOTH")
    }
    
    class func setUserToken(_ UserID: String)->(){
        UserDefaults.standard.set(UserID, forKey: "USERToken")
    }
    
    class func getProjectId()->(String?){
        return UserDefaults.standard.value(forKey: "ProjectId") as? String
    }
    class func setProjectId(_ UserID: String)->(){
        UserDefaults.standard.set(UserID, forKey: "ProjectId")
    }
    
    class func getClientId()->(String?){
        return UserDefaults.standard.value(forKey: "ClientId") as? String
    }
    class func setClientId(_ UserID: String)->(){
        UserDefaults.standard.set(UserID, forKey: "ClientId")
    }
    
    class func getUserToken()->(String?){
        return UserDefaults.standard.value(forKey: "USERToken") as? String
    }
    
    class func setDevice(_ deviceID: String)->(){
        UserDefaults.standard.set(deviceID, forKey: "DEVICEID")
    }
    
    class func getDevice()->(String?){
        return UserDefaults.standard.value(forKey: "DEVICEID") as? String
    }
    
    class func getBeaconServices()->(String?){
        return UserDefaults.standard.value(forKey: "BeaconServices") as? String
    }
    class func setBeaconServices(_ UserID: String)->(){
        UserDefaults.standard.set(UserID, forKey: "BeaconServices")
    }
    
    class func setUserRole(_ UserID: String)->(){
        UserDefaults.standard.set(UserID, forKey: "UserRole")
    }
    
    class func getUserRole()->(String?){
        return UserDefaults.standard.value(forKey: "UserRole") as? String
    }
    
    class func setBaseUrl(_ baseUrl: String)->(){
        UserDefaults.standard.set(baseUrl, forKey: "BaseUrl")
    }
    
    class func getBaseUrl()->(String?){
        return UserDefaults.standard.value(forKey: "BaseUrl") as? String
    }
    class func setAPIStage(_ baseUrl: String)->(){
        UserDefaults.standard.set(baseUrl, forKey: "APIStage")
    }
    
    class func getAPIStage()->(String?){
        return UserDefaults.standard.value(forKey: "APIStage") as? String
    }
    
    class func setIdToken(_ token: String){
        UserDefaults.standard.set(token, forKey: "IDTOKEN")
    }
    class func getIdToken()->(String!){
        let pt = UserDefaults.standard.value(forKey: "IDTOKEN") as? String
        if(pt != nil)
        {
            return pt
        }
        else{
            return ""
        }
        return UserDefaults.standard.value(forKey: "IDTOKEN") as? String
    }
    
    
    class func setAccessToken(_ token: String){
        UserDefaults.standard.set(token, forKey: "ACCESSTOKEN")
    }
    class func getAccessToken()->(String!){
        let pt = UserDefaults.standard.value(forKey: "ACCESSTOKEN") as? String
        if(pt != nil)
        {
            return pt
        }
        else{
            return ""
        }
        return UserDefaults.standard.value(forKey: "ACCESSTOKEN") as! String
    }
    
}
