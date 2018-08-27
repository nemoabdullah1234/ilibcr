//
//  AKThingsUpdate.swift
//  AKAdmin
//
//  Created by Amarendra on 11/8/17.
//  Copyright © 2017 Akwa. All rights reserved.
//

import UIKit
import KontaktSDK
class AKThingsUpdate: NSObject {
    enum SyncResult  {
        case configFetchFailed(String)
        case configUpdateFailed(KTKDeviceConfiguration?)
        case syncSuccess(KTKDeviceConfiguration?)
        case deviceArrayEmpty(String)
        case configArrayEmpty(String)
    }
    open static let sharedHandler:AKThingsUpdate = AKThingsUpdate()
    var count = 0
    var dataSource = [KTKNearbyDevice]()
    var devicesManager: KTKDevicesManager!
    var deviceConfiguration:[KTKDeviceConfiguration]?
    var success: ((SyncResult)->())? = nil
    var failure: ((SyncResult)->())? = nil
    var updateTimer:Timer?
    override init() {
        super.init()
        //Do aditional initializations here
        devicesManager = KTKDevicesManager(delegate: self)
         // if devicesManager.centralState == .poweredOn {

        
        // }
    }
     @objc func initiateUpdate(){
        self.devicesManager.stopDevicesDiscovery()
        self.updateTimer?.invalidate()
        self.updateTimer = nil
        if(deviceConfiguration?.count == 0)
        {
            if (self.failure != nil)
            {
                self.failure!(.configArrayEmpty("config array empty"))
            }
            
        }
        for (i,config) in deviceConfiguration!.enumerated().reversed(){
            if let device = dataSource.first(where: {$0.uniqueID == config.uniqueID }) {
            AKSyncConfiguration().update(device: device, config: config, success: {(configuration) in
                if (self.success != nil)
                {
                    self.success!(.syncSuccess(configuration))
                }
                
                            }, failure: {(configuration) in
                                if (self.failure != nil)
                                {
                                    self.failure!(.configUpdateFailed(configuration))
                                }
                            })
            }
            deviceConfiguration?.remove(at: i);

        }
  }
    
    func startUpdate(success:((SyncResult)->())?,failure:((SyncResult)->())?){
        self.devicesManager.startDevicesDiscovery(withInterval: 2.0)
        if(count == 2){
            count = 0;
            if (failure != nil) {
                failure!(.configFetchFailed("configfetchFailed"))
            }
            return
        };
        if (failure != nil && success != nil)
        {
        self.failure = failure!
        self.success = success!
        }
        _ = AKFetchConfiguration.init(configurationdata: { (array) in
            self.deviceConfiguration?.removeAll()
            self.deviceConfiguration = array
            if(array.count > 0)
            {
              //start device discovery
               if (self.updateTimer != nil)
               {
                self.updateTimer?.invalidate()
                self.updateTimer =  nil
                }
                self.updateTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: (#selector(AKThingsUpdate.initiateUpdate)), userInfo: nil, repeats: true)
                
            }
            else{
                self.devicesManager.stopDevicesDiscovery()
                if (failure != nil) {
                self.failure!(.deviceArrayEmpty("No configuration to update"))
                }
            }
            
        }, errorBlock: {
            self.count += 1
            self.startUpdate(success: nil,failure: nil)
        })
    }
    deinit{
        devicesManager.stopDevicesDiscovery()
    
    }
    
}
extension AKThingsUpdate: KTKDevicesManagerDelegate{
    func devicesManager(_ manager: KTKDevicesManager, didDiscover devices: [KTKNearbyDevice]?) {
        guard let nearbyDevices = devices else {
            return
        }
        for  device in nearbyDevices{
            if !dataSource.contains(device){
                dataSource.append(device)
            }
        }
    }
}
