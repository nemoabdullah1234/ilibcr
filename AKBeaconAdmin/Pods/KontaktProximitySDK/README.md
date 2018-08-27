<p align="center">
  <img src="https://kontakt-mobile.s3.amazonaws.com/proximity-icon.png">
</p>

Kontakt.io iOS Proximity SDK
===========

The Kontakt.io Proximity SDK provides the simplest way to manage triggers and all proximity-based actions with just few lines of code. The main functionalitites offered by the SDK are:

* fetching and resolving triggers,
* monitoring iBeacon regions,
* monitoring Eddystone regions,
* data synchronization.

## Latest Version

Latest version is 1.0.0

## Setup

TODO

## Before you start

Remember that you need to include [KontaktSDK](https://github.com/kontaktio/kontakt-ios-sdk) at first because the new SDK is built upon it. The latest version of ProximitySDK is compatible with [KontaktSDK version 1.4.3](https://github.com/kontaktio/kontakt-ios-sdk/releases/tag/v1.4.3).

## Usage

The biggest advantage of Kontakt.io Proximity SDK is the usage simplicity. The provided interface allows us to manage triggers and monitor iBeacon & Eddystone regions in very simple way. The whole stuff is enclosed within single component which is `ProximityManager`. 

### Initialize Kontakt SDK

New SDK requires API Key to be specified. You can get it by registering a free account at our [Web Panel](https://panel.kontakt.io). Afterward you should set this value somewhere in code. The best place could be `AppDelegate`'s method `didFinishLaunchingWithOptions`:


``` Swift
import KontaktSDK

// ...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Set API key
    Kontakt.setAPIKey("YOUR-API-KEY")
    
    return true
}
```

### Instantiate Proximity Manager

There are two ways of creating `ProximityManager` component - it can be initialized with or without delegate. If you decide to react on particular events through completion handlers you can initialize it without any parameters. Otherwise you should pass delegate's object and implement your callback's logic within delegate's methods.

``` Swift
import ProximitySDK

class ProximityManagerViewController: UIViewController {

	var proximityManager: KTKProximityManager!

	override func viewDidLoad() {
	    super.viewDidLoad()
	    
        // 1. Initialize Proximity Manager with delegate
        self.proximityManager = KTKProximityManager(delegate: self)
        
        // 2. Initialize Proximity Manager without delegate
        self.proximityManager = KTKProximityManager()
	}

}

extension ProximityManagerViewController: KTKProximityManagerDelegate {

	// ...

}
```


### Monitor triggers

In order to monitor any triggers you have to create them at first. You can do it by using our [Web Panel](https://panel.kontakt.io). Another approach is to execute HTTP POST request and create them via `KTKCloudClient`. It is up to you to choose an approach. Anyway, keep in mind that **only triggers with executor type PROXIMITY_SDK** will be fetched and monitored by the SDK.

To listen for triggers we need to invoke `monitorTriggers` method with completion handler. Every time a trigger is executed we will get notified about it through this handler.

``` Swift
self.proximityManager.monitorTriggers({ (trigger: KTKTrigger?, error: Error?) in
    if (error == nil) {
        // Trigger executed successfully
    } else {
        // Trigger execution error
    }
})
```

Alternatively you can listen for trigger events using delegate:

``` Swift
extension ProximityManagerViewController: KTKProximityManagerDelegate {

    func proximityManager(_ manager: KTKProximityManager, didExecute trigger: KTKTrigger?, error: Error?) {
        if (error == nil) {
            // Trigger executed successfully
        } else {
            // Trigger execution error
        }
    }
    
    func proximityManager(_ manager: KTKProximityManager, triggersInitDidFail error: Error) {
        // Triggers initialization error - not fetched or not stored properly
    }
    
    func proximityManager(_ manager: KTKProximityManager, triggersSyncDidFail error: Error) {
        // Triggers synchronization failed
    }

}
```

### Monitor iBeacon regions

Monitoring regions is very simple. Everything that has to be done is just to define single or multiple regions and pass them to the `monitorBeaconRegion` or `monitorBeaconRegions` method:

``` Swift
import KontaktSDK
import ProximitySDK

// ...

// Create iBeacon region
let proximityUUID = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
let beaconRegion = KTKBeaconRegion(proximityUUID: proximityUUID!, major: 125, minor: 459, identifier: "beacon_region")

// Start monitoring iBeacons
self.proximityManager.monitorBeaconRegion(beaconRegion, onEnter: { (region: KTKBeaconRegion, beacons: [CLBeacon]) in
    // Entered region with iBeacons
}, onExit: { (region: KTKBeaconRegion) in
    // Exit region
})
```

Or with delegate:

``` Swift
self.proximityManager.monitorBeaconRegion(beaconRegion)

// ...

extension ProximityManagerViewController: KTKProximityManagerDelegate {

    func proximityManager(_ manager: KTKProximityManager, didEnter region: KTKBeaconRegion, with beacons: [CLBeacon]) {
		// Entered region with iBeacons
    }
    
    func proximityManager(_ manager: KTKProximityManager, didExitBeaconRegion region: KTKBeaconRegion) {
        // Exit region
    }
    
    func proximityManager(_ manager: KTKProximityManager, didFailMonitoringFor region: KTKBeaconRegion?, withError error: Error) {
       // Monitoring did fail
    }

}
```

### Monitor eddystone regions

Tracking eddystone regions is almost the same as in the case of iBeacon regions:

``` Swift
import KontaktSDK
import ProximitySDK

// ...

// Create Eddystone region
let eddystoneRegion = KTKEddystoneRegion(namespaceID: "f7826da6bc5b71e0893e", instanceID: "76484d755758")

// Start eddystones monitoring
self.proximityManager.monitorEddystoneRegion(eddystoneRegion, onEnter: { (region: KTKEddystoneRegion, eddystones: Set<KTKEddystone>) in
	// Entered region with eddystones
}, onExit: { (region: KTKEddystoneRegion) in
  	// Exit region
})
```

Of course you can use delegate instead:

``` Swift
self.proximityManager.monitorEddystoneRegion(eddystoneRegion)

// ...

extension ProximityManagerViewController: KTKProximityManagerDelegate {

    func proximityManager(_ manager: KTKProximityManager, didEnter region: KTKEddystoneRegion, with eddystones: Set<KTKEddystone>) {
		// Entered region with eddystones
    }
    
    func proximityManager(_ manager: KTKProximityManager, didExitEddystoneRegion region: KTKEddystoneRegion) {
        // Exit region
    }
    
    func proximityManager(_ manager: KTKProximityManager, didFailDiscovery error: Error) {
        // Eddystones discovery failed
    }

}
```

### Mix it up!

If you are interested in monitoring triggers and regions at the same time there are no objections to it.

``` Swift
// Monitor triggers
self.proximityManager.monitorTriggers({ (trigger: KTKTrigger?, error: Error?) in
    if (error == nil) {
        // Trigger executed successfully
    } else {
        // Trigger execution error
    }
})

// Monitor iBeacons
let proximityUUID = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
let beaconRegion = KTKBeaconRegion(proximityUUID: proximityUUID!, major: 125, minor: 459, identifier: "beacon_region")

self.proximityManager.monitorBeaconRegion(beaconRegion, onEnter: { (region: KTKBeaconRegion, beacons: [CLBeacon]) in
    // Entered region with iBeacons
}, onExit: { (region: KTKBeaconRegion) in
    // Exit region
})

// Monitor eddystones
let eddystoneRegion = KTKEddystoneRegion(namespaceID: "f7826da6bc5b71e0893e", instanceID: "76484d755758")

self.proximityManager.monitorEddystoneRegion(eddystoneRegion, onEnter: { (region: KTKEddystoneRegion, eddystones: Set<KTKEddystone>) in
	// Entered region with eddystones
}, onExit: { (region: KTKEddystoneRegion) in
  	// Exit region
})
```

## Summary

The main objective of this SDK is to provide as simple interface as it's possible. Consequently, such a solution enables quick and easy integration with any customer's application. It's worth to mention again that all previously mentioned functionalities can be mixed up. We can monitor triggers and regions at the same time or separately. As a result the provided SDK is at your service - you can choose modules and configure settings to get a desired coverage of your needs. 

Compared to our original SDK, this one is more simplified and can be adapted in your projects very easily. It's perfect choice if you want to keep track of all proximity-based actions with minimal effort. Anyway, please note that Kontakt.io Proximity SDK doesn't cover all functionality from the core module. 
