import UIKit
import CoreLocation
import KontaktSDK

public var saveFactor = 0.00
@objc open class BeaconHandler: NSObject , NBProximityLocationManagerDelegate, AKKontaktSDKLocationManagerDelegate{
    open static let sharedHandler:BeaconHandler = BeaconHandler()
    var  locationManager:NBProximityManager?
    var kontaktHandler : AKKontaktHandler?
    var  beacon:CLBeaconRegion?
    var region: KTKBeaconRegion?
    var _closureToScanItems:(([CLBeacon])->())?
    open var _closureOperationStop:(()->())?
    open var _closureAuthChange:(()->())?
    open var _closureUpdate:((_ beacon:[CLBeacon],_ PKSyncObj:String,_ coordinate:CLLocationCoordinate2D)->())?
    open var coordinate:CLLocationCoordinate2D?
    open var PKSyncObj:String?
    public var isEnabledKontaktSDK : Bool?
     var concurrentApplicationStateQueue: DispatchQueue?
    fileprivate var beaconUdid:String = ""
    
    var passcount = 10
    override init() {
        
        super.init()
        
        locationManager = NBProximityManager()
        kontaktHandler =  AKKontaktHandler()
        
        //initiateRegion(self)
    }
   
    
    open  func dummy(_ coord:CLLocationCoordinate2D){
        // if(self.passcount < 10)
        //  {
        //     return
        // }
        coordinate = coord
        PKSyncObj = "\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))".replacingOccurrences(of: ".", with: "")
        if isEnabledKontaktSDK! {
            kontaktHandler?.akKontaktStopRangingBeaconsInRegion(region!)
            kontaktHandler?.akKontaktStartRangingBeaconsInRegion(region!)
        }else{
            locationManager?.nbStopRangingBeaconsInRegion(beacon!)
            locationManager?.nbStartRangingBeaconsInRegion(beacon!)
        }
    }
    open func initiateResponseBlocks(_ operationStopped:(()->())!, authenticationChanged:(()->())! ,updateBeaconInformation:((_ beacon:[CLBeacon],_ PKSyncObj:String,_ coordinate:CLLocationCoordinate2D)->())? ){
        
        self._closureUpdate = updateBeaconInformation;
        self._closureAuthChange = authenticationChanged;
        self._closureOperationStop = operationStopped;
    }
   
    func locationData()->(CLLocationCoordinate2D){
        if(self.coordinate != nil)
        {
        return self.coordinate!
        }
        return kCLLocationCoordinate2DInvalid
    }

    
    
    func startBeconOperation(_ coord:CLLocationCoordinate2D?){
        if(self.passcount < 10)
        {
            return
        }
        coordinate = coord
        PKSyncObj = "\(Int64(floor(Date().timeIntervalSince1970 * 1000.0)))".replacingOccurrences(of: ".", with: "")
        if isEnabledKontaktSDK! {
            kontaktHandler?.akKontaktStopRangingBeaconsInRegion(region!)
            kontaktHandler?.akKontaktStartRangingBeaconsInRegion(region!)
        }else{
            locationManager?.nbStopRangingBeaconsInRegion(beacon!)
            locationManager?.nbStartRangingBeaconsInRegion(beacon!)
        }
        
    }
   
   open func stopBeconOperation(){
        
        self._closureOperationStop?()
        if isEnabledKontaktSDK! {
          kontaktHandler?.akKontaktStopRangingBeaconsInRegion(region!)
       
        }else{
        locationManager?.nbStopRangingBeaconsInRegion(beacon!)
        
        }
    
        self.passcount = 10
    }
    
    func startRanging(){
        if isEnabledKontaktSDK! {
            kontaktHandler?.akKontaktStartRangingBeaconsInRegion(region!)
        }else{
            locationManager?.nbStartRangingBeaconsInRegion(beacon!)
        }
    }
    func stopRanging(){
        if isEnabledKontaktSDK! {
            kontaktHandler?.akKontaktStopRangingBeaconsInRegion(region!)
        }else{
            locationManager?.nbStopRangingBeaconsInRegion(beacon!)
        }
    }
    
    public func setBeaconUdid(_ beaconUdid:String){
        
            self.beaconUdid = beaconUdid
        
    }
    
    public func getBeaconUdid()->String{
        var str: String?
            str = self.beaconUdid
        return ((str! == "") ?"B9407F30-F5F8-466E-AFF9-25556B57FE6D":str!)//B9407F30-F5F8-466E-AFF9-25556B57FE6D
    }
    
    open func initiateRegion(_ ref:BeaconHandler){
        let uuid:UUID = UUID(uuidString: getBeaconUdid())!
        //beacon = CLBeaconRegion(proximityUUID: uuid, major:1,minor: 100, identifier: "")

        
        
        CLLocationManager.locationServicesEnabled()
        
        
        
        if isEnabledKontaktSDK! {
           region = KTKBeaconRegion(proximityUUID: uuid, identifier: "")
            region?.notifyOnEntry=true
            region?.notifyOnExit=true
            region?.notifyEntryStateOnDisplay=true
            kontaktHandler?.akKontaktStartRangingBeaconsInRegion(region!)
            kontaktHandler?.delegate  = ref;
            
        }else{
            beacon = CLBeaconRegion(proximityUUID: uuid, identifier:"")
            locationManager?.nbRequestAlwaysAuthorization()  //requestAlwaysAuthorization()
            beacon?.notifyOnEntry=true
            beacon?.notifyOnExit=true
            beacon?.notifyEntryStateOnDisplay=true
            
            
            locationManager?.nbStartRangingBeaconsInRegion(beacon!)
            locationManager?.delegate = ref;
           
        }
        if #available(iOS 9.0, *) {
            locationManager!.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        };
        
        

        // Check if beacon monitoring is available for this device
        if (!CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)) {
            // print("error")
        }
    }
    
    func canDeviceSupportAppBackgroundRefresh()->Bool
    {
        if UIApplication.shared.backgroundRefreshStatus == UIBackgroundRefreshStatus.available
        {
            // createAlert("Background Refresh Status", alertMessage: "Background Updates are enable for the App", alertCancelTitle: "OK")
            return true;
        }
        else if UIApplication.shared.backgroundRefreshStatus == UIBackgroundRefreshStatus.denied
        {
            createAlert("Background Refresh Status", alertMessage: "Background Updates are disabled by the user for the App", alertCancelTitle: "OK")
            return false;
        }
        else if UIApplication.shared.backgroundRefreshStatus == UIBackgroundRefreshStatus.restricted
        {
            createAlert("Background Refresh Status", alertMessage: "Background Updates are restricted and the user can't enable it", alertCancelTitle: "OK")
            return false
        }
        
        return false
    }
    
    func createAlert(_ alertTitle: String, alertMessage: String, alertCancelTitle: String)
    {
        
        
        let alert = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: alertCancelTitle)
        alert.show()
    }
    
    
    
    
    open func nbProximityManager(_ manager: NBProximityManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //  NBLocationUpdateHandler.sharedHandler.nbScannerstate()
        self._closureAuthChange?()
        if(!NBProximityManager.nbLocationServicesEnabled())
        {
        
        }
        if(NBProximityManager.nbAuthorizationStatus() != CLAuthorizationStatus.authorizedAlways )
        {
        
        }
    }
    open func nbProximityManager(_ manager: NBProximityManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        if (state ==  CLRegionState.inside)
        {
            
        }
        else if(state ==  CLRegionState.outside)
        {
        }
        else
        {
            //locationManager!.stopRangingBeaconsInRegion(self.beacon!)
            
        }
    }
    
    open func akKontaktProximityManager(_ manager: AKKontaktHandler, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //  NBLocationUpdateHandler.sharedHandler.nbScannerstate()
        self._closureAuthChange?()
        if(!AKKontaktHandler.akKontaktLocationServicesEnabled())
        {
            
        }
        if(AKKontaktHandler.akKontaktAuthorizationStatus() != CLAuthorizationStatus.authorizedAlways )
        {
            
        }
    }
    
    open func akKontaktProximityManager(_ manager: AKKontaktHandler, didDetermineState state: CLRegionState, forRegion region: KTKBeaconRegion)
    {
        if (state ==  CLRegionState.inside)
        {
            
        }
        else if(state ==  CLRegionState.outside)
        {
        }
        else
        {
            //locationManager!.stopRangingBeaconsInRegion(self.beacon!)
            
        }
    }
    
   
    open func akKontaktProximityManager(_ manager: AKKontaktHandler, didEnterRegion region: KTKBeaconRegion)
    {
        manager.akKontaktStartRangingBeaconsInRegion(self.region!)
    }
    
    open func nbProximityManager(_ manager: NBProximityManager, didEnterRegion region: CLRegion) {
        //  utility.shoaNotification("ENTER", message: "ENTER")

        manager.nbStartRangingBeaconsInRegion(self.beacon!)
        
        // if(region .isKindOfClass(CLCircularRegion))
        // {

        // }
        // else if(region.isKindOfClass(CLBeaconRegion))
        // {
            
        //  locationManager!.startRangingBeaconsInRegion(self.beacon!)
            //   LocationTracker().startLocationTracking()
            
           
        //   LocationUpdateHandler.sharedHandler.stopSync()
        //      LocationUpdateHandler.sharedHandler.initiateTimer()
                //    if(UIApplication.sharedApplication().applicationState == UIApplicationState.Background )
        //{
        //       LocationTracker().applicationEnterBackground()
        //   }
        // }
    }
    open func akKontaktProximityManager(_ manager: AKKontaktHandler, didExitRegion region: KTKBeaconRegion)
    {
        if(region .isKind(of: CLCircularRegion.self))
        {
            
        }
        else if(region.isKind(of: CLBeaconRegion.self))
        {
            //  self.locationManager!.stopRangingBeaconsInRegion(self.beacon!)
            //   LocationTracker().stopLocationTracking()
            // LocationUpdateHandler.sharedHandler.stopSync()
        }
    }
    
    open func nbProximityManager(_ manager: NBProximityManager, didExitRegion region: CLRegion) {
        //   utility.shoaNotification("EXIT", message: "EXIT")
        if(region .isKind(of: CLCircularRegion.self))
        {

        }
        else if(region.isKind(of: CLBeaconRegion.self))
        {
            //  self.locationManager!.stopRangingBeaconsInRegion(self.beacon!)
            //   LocationTracker().stopLocationTracking()
            // LocationUpdateHandler.sharedHandler.stopSync()
        }
    }
    open func akKontaktProximityManager(_ manager: AKKontaktHandler, didRangeBeacons beacons: [CLBeacon], inRegion region: KTKBeaconRegion)
    {
        if(self._closureToScanItems != nil)
        {
            self._closureToScanItems!(beacons)
        }
        if(beacons.count == 0){
            // locationManager!.stopRangingBeaconsInRegion(self.beacon!)
            self._closureUpdate?(beacons, self.PKSyncObj!,self.coordinate!)
            //return
        }
        if( self.passcount >= 0 )
        {
            self.passcount = passcount - 1
            // dispatch_async(dispatch_queue_create("background_update", nil), {
            // self.updateSyncBeaconData(beacons)
            //   })
            self._closureUpdate?(beacons, self.PKSyncObj!,self.coordinate!)
        }
        else
        {
            
            self.stopBeconOperation()
        }
        
    }
    
    open func nbProximityManager(_ manager: NBProximityManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        
        if(self._closureToScanItems != nil)
        {
            self._closureToScanItems!(beacons)
        }
        if(beacons.count == 0){
            // locationManager!.stopRangingBeaconsInRegion(self.beacon!)
            return
        }
        if( self.passcount > 0 )
        {
            self.passcount = passcount - 1
            // dispatch_async(dispatch_queue_create("background_update", nil), {
                // self.updateSyncBeaconData(beacons)
            //   })
            self._closureUpdate?(beacons, self.PKSyncObj!,self.coordinate!)
        }
        else
        {
            
            self.stopBeconOperation()
        }
        
    }
    
    
}
