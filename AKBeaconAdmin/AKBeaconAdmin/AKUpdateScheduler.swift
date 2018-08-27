//
//  AKUpdateScheduler.swift
//  AKAdmin
//
//  Created by Amarendra on 11/8/17.
//  Copyright © 2017 Akwa. All rights reserved.
//

import UIKit
import KontaktSDK
public protocol AKUpdateSchedulerDelegate{
    func configUpdateSuccess(config:KTKDeviceConfiguration?,description:String)
    func configUpdateFailure(config:KTKDeviceConfiguration?,description:String)
}
public enum SyncCredentials{
    case kontakBeacons(APIKey: String)
}
public class AKUpdateScheduler: NSObject {
    open static let updatescheduler: AKUpdateScheduler = AKUpdateScheduler()
    var scheduler:Timer!
    var thingsUpdater: AKThingsUpdate?
    var delegate:AKUpdateSchedulerDelegate?
   
    public static func setupCredentials(credentials:SyncCredentials){
    switch credentials{
    case .kontakBeacons(let APIKey):
        Kontakt.setAPIKey(APIKey)
    }
    }
    open func schduleSyncAfter(interval: Double, delegate:AKUpdateSchedulerDelegate){
        print("\(interval)")
        self.scheduler = Timer.scheduledTimer(timeInterval: interval, target: self, selector: (#selector(AKUpdateScheduler.startSync)), userInfo: nil, repeats: true)
        self.delegate = delegate
    }
    
    @objc func startSync(){
        thingsUpdater = nil;
        thingsUpdater = AKThingsUpdate()
        thingsUpdater?.startUpdate(success: {(status) in
            switch status {
            case .syncSuccess(let Description):
                print("success \(Description?.uniqueID ?? "")")
                self.delegate?.configUpdateSuccess(config:Description , description: "Config Update Successfull")
            default:
                print("success")
             
            }
        }, failure: { (status) in
            switch status {
            case .configFetchFailed(let Description):
                print("success \(Description)")
                self.delegate?.configUpdateFailure(config:nil , description: "Could not fetch configuration from server")
            case .configUpdateFailed(let Description):
                print("success \(Description?.uniqueID ?? "" )")
                self.delegate?.configUpdateFailure(config:Description , description: "Could not update configuration")
            case .deviceArrayEmpty(let Description):
                 self.delegate?.configUpdateFailure(config:nil , description: Description)
            case .configArrayEmpty(let Description):
                self.delegate?.configUpdateFailure(config:nil , description: Description)
            default:
                print("Failled")
                 self.delegate?.configUpdateFailure(config:nil , description: "Could not update configuration")
                
            }
        })
    }
}
