//
//  LocationShareModel.swift
//  TrackingDemo
//
//  Created by Amarendra on 11/13/17.
//  Copyright © 2017 Akwa. All rights reserved.
//

import UIKit
import CoreLocation
class LocationShareModel: NSObject {
    var timer: Timer?
    var delay10Seconds: Timer?
    var speedTimer:Timer?
    var stateTimer:Timer?
    var speedTimerInactive:Bool = true
    var bgTask: BackgroundTaskManager = BackgroundTaskManager.sharedBackgroundTaskManager
    public static let sharedModel : LocationShareModel = LocationShareModel()
    override init() {
        super.init()
    }
}
