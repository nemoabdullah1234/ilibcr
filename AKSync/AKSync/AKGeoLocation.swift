
//

import UIKit
import CoreLocation
import RealmSwift

//minimum radius is said to be 100m
@objc public class AKGeoLocation: Object {
    @objc dynamic open var locationName : String = " "
    @objc dynamic open var lattitude    : Double = 0.0
    @objc dynamic open var longitude    : Double = 0.0
    @objc dynamic open var radius       : NSInteger = 0
    @objc dynamic open var identifier   : String = ""
    open let event = List<AKEvent>()
    open override static func primaryKey() -> String? {
        return "identifier"
    }
}


@objc public class AKBeacon: Object{
    @objc dynamic open var name: String = ""
    @objc dynamic open var id: String = ""
    open let event = List<AKEvent>()
    override open static func primaryKey() -> String? {
        return "id"
    }
}

@objc public class AKEvent:Object {
    @objc dynamic open var eventType: String = ""
    @objc dynamic open var eventName: String = ""
    @objc dynamic open var eventDescription: String = ""
    @objc dynamic open var eventDate: Date?
}

enum  AKEventType: Int {
    case onEntryGeofence=0
    case onExitGeofence=1
    case onbeaconTransit=2
}
@objc public class AKBeaconInfo: Object {
    @objc dynamic open var cid:  String = ""
    @objc dynamic open var data: String = ""
    @objc dynamic open var lat:  String = ""
    @objc dynamic open var long: String = ""
    @objc dynamic open var timestamp: String = ""
    @objc dynamic open var uuid:   String = ""
    @objc dynamic open var major:  String = ""
    @objc dynamic open var minor:  String = ""
    @objc dynamic open var proximity:  String = ""
    @objc dynamic open var distance:  String = ""
    @objc dynamic open var rssi:  String = ""
    
    @objc dynamic open var synced: Bool = false
    @objc dynamic open var id: String = ""
    
    override open static func primaryKey() -> String? {
        return "id"
    }
    
}
@objc public class AKSyncObject: Object{
    @objc dynamic open var id: String = ""
    @objc dynamic open var synced: Bool = false
    @objc dynamic open var lat :String = ""
    @objc dynamic open var lng :String = ""
    @objc dynamic open var alt:String = ""
    @objc dynamic open var accuracy: String = ""
    @objc dynamic open var speed:String = ""
    @objc dynamic open var direction:String = ""
    @objc dynamic open var provider:String = ""
    @objc dynamic open var pkid : String = ""
    open  let event = List<AKBeaconInfo>()
    override open static func primaryKey() -> String? {
        return "id"
    }
}

@objc public class AKTimeStamp:Object {
    @objc dynamic open var timeStamp:String = ""
    @objc dynamic open var syncEvent:String = ""
}
