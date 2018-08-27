//
//  AKFetchConfiguration.swift
//  TraKit-Admin
//
//  Created by Amarendra on 11/7/17.
//  Copyright © 2017 Akwa. All rights reserved.
//

import UIKit
import KontaktSDK
class AKFetchConfiguration: NSObject {
let apiClient3 = KTKCloudClient.sharedInstance()
var successBlock:(Array<KTKDeviceConfiguration>)->()
    var failureBlock:()->()
var arryOfConfig = [KTKDeviceConfiguration]()
    init(configurationdata dataBlock:@escaping(Array<KTKDeviceConfiguration>)->(),errorBlock:@escaping()->()) {
        successBlock = dataBlock;
        failureBlock =  errorBlock;
        super.init()
        getPendingConfiguration()
    }

    func getPendingConfiguration(){
        let parameters = ["deviceType": "beacon"]
        KTKCloudClient.sharedInstance().getObjects(KTKDeviceConfiguration.self, parameters: parameters) { response, error in
            if KTKCloudErrorFromError(error) != nil {
                self.failureBlock()
            } else if let configs = response?.objects as? [KTKDeviceConfiguration] {
                for config in configs {
                    if !self.arryOfConfig.contains(config){
                        self.arryOfConfig.append(config)
                    }
                }
                self.successBlock(configs)
            } else{
                self.failureBlock()
            }
            
        }
        
    }
    
    func getConfiguration()->Array<KTKDeviceConfiguration>{
        return arryOfConfig
    }
    
}
