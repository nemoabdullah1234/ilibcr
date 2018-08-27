//
//  AKSyncConfiguration.swift
//  TraKit-Admin
//
//  Created by Amarendra on 11/7/17.
//  Copyright © 2017 Akwa. All rights reserved.
//

import UIKit
import KontaktSDK
class AKSyncConfiguration: NSObject {
    var nearByDevice: KTKNearbyDevice!
    var newConfig: KTKDeviceConfiguration!
    func update(device:KTKNearbyDevice , config:KTKDeviceConfiguration , success:@escaping (KTKDeviceConfiguration?)->() ,failure:@escaping (KTKDeviceConfiguration?)->())
    {
        print("\(config.uniqueID ?? "")")
        let connection = KTKDeviceConnection(nearbyDevice: device)
        connection.write(config) { synchronized, configuration, error in
            if error == nil {
                if !synchronized, let config = configuration {
                    //save config
                    print(config)
                   
                }
                 success(configuration);
            }else {
                failure(configuration)
            }
        }
    }
}
