//
//  KontaktSDK
//
//  Copyright © 2017 Kontakt.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KontaktSDK/KTKTrigger.h>
#import <KontaktSDK/KTKBeaconRegion.h>
#import <KontaktSDK/KTKEddystone.h>
#import <KontaktSDK/KTKEddystoneRegion.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Blocks
// Trigger Block
typedef void (^KTKTriggerBlock)(KTKTrigger * _Nullable, NSError * _Nullable);

// iBeacon Monitoring Blocks
typedef void (^KTKBeaconRegionEnteredBlock)(KTKBeaconRegion *, NSArray<CLBeacon *> *);
typedef void (^KTKBeaconRegionExitBlock)(KTKBeaconRegion *);

// Eddystone Monitoring Blocks
typedef void (^KTKEddystoneRegionEnteredBlock)(KTKEddystoneRegion *, NSSet<KTKEddystone *> *);
typedef void (^KTKEddystoneRegionExitBlock)(KTKEddystoneRegion *);

#pragma mark - Delegate Declaration
@protocol KTKProximityManagerDelegate;

#pragma mark - Constants
// Error Domain Constant
extern NSString * const KTKProximityManagerErrorDomain;

#pragma mark - Enums
// Error codes
typedef NS_ENUM(uint8_t, KTKProximityManagerErrorCode) {
    KTKProximityManagerErrorCodeTriggersNotDefined          = 0x00,
    KTKProximityManagerErrorCodeTriggersWithInvalidContent  = 0x01,
    KTKProximityManagerErrorCodeTriggerExecutionFailure     = 0x02,
    KTKProximityManagerErrorCodeTriggerSyncFailure          = 0x03,
    KTKProximityManagerErrorCodeInvalidBeaconRegions        = 0x04,
    KTKProximityManagerErrorCodeInvalidEddystoneRegions     = 0x05,
    KTKProximityManagerErrorCodePersistenceFailure          = 0x06
};

// Beacon Manager events
typedef NS_ENUM(uint8_t, KTKBeaconManagerEvent) {
    KTKBeaconManagerEventRegionEntered  = 0x00,
    KTKBeaconManagerEventRegionExit     = 0x01
};

// Eddystone Manager events
typedef NS_ENUM(uint8_t, KTKEddystoneManagerEvent) {
    KTKEddystoneManagerEventRegionEntered  = 0x00,
    KTKEddystoneManagerEventRegionExit     = 0x01
};

#pragma mark - KTKEddystoneManager (Interface)
@interface KTKProximityManager : NSObject

#pragma mark - Properties
///--------------------------------------------------------------------
/// @name Properties
///--------------------------------------------------------------------

@property (nonatomic, weak, readwrite) id<KTKProximityManagerDelegate> _Nullable delegate;

#pragma mark - Initialization Methods
///--------------------------------------------------------------------
/// @name Initialization Methods
///--------------------------------------------------------------------

- (instancetype)initWithDelegate:(id<KTKProximityManagerDelegate> _Nullable)delegate;

#pragma mark - Triggers
///--------------------------------------------------------------------
/// @name Triggers
///--------------------------------------------------------------------

- (void)monitorTriggersWithBlock:(KTKTriggerBlock)block;

- (void)monitorTriggers;

#pragma mark - iBeacons Monitoring
///--------------------------------------------------------------------
/// @name iBeacons Monitoring
///--------------------------------------------------------------------

- (void)monitorBeaconRegion:(KTKBeaconRegion *)region
                    onEnter:(KTKBeaconRegionEnteredBlock)enterBlock
                     onExit:(KTKBeaconRegionExitBlock)exitBlock;

- (void)monitorBeaconRegion:(KTKBeaconRegion *)region;

- (void)monitorBeaconRegions:(NSArray<KTKBeaconRegion *> *)regions
                     onEnter:(KTKBeaconRegionEnteredBlock)enterBlock
                      onExit:(KTKBeaconRegionExitBlock)exitBlock;

- (void)monitorBeaconRegions:(NSArray<KTKBeaconRegion *> *)regions;

#pragma mark - Eddystone Monitoring
///--------------------------------------------------------------------
/// @name Eddystone Monitoring
///--------------------------------------------------------------------

- (void)monitorEddystoneRegion:(KTKEddystoneRegion *)region
                    onEnter:(KTKEddystoneRegionEnteredBlock)enterBlock
                     onExit:(KTKEddystoneRegionExitBlock)exitBlock;

- (void)monitorEddystoneRegion:(KTKEddystoneRegion *)region;

- (void)monitorEddystoneRegions:(NSArray<KTKEddystoneRegion *> *)regions
                     onEnter:(KTKEddystoneRegionEnteredBlock)enterBlock
                      onExit:(KTKEddystoneRegionExitBlock)exitBlock;

- (void)monitorEddystoneRegions:(NSArray<KTKEddystoneRegion *> *)regions;

#pragma mark - Cleanup Methods
///--------------------------------------------------------------------
/// @name Cleanup Methods
///--------------------------------------------------------------------

- (void)stop;

- (void)reset;

@end

#pragma mark - KTKProximityManagerDelegate
///--------------------------------------------------------------------
/// @name KTKProximityManagerDelegate
///--------------------------------------------------------------------
@protocol KTKProximityManagerDelegate <NSObject>

@optional

#pragma mark - Triggers
///--------------------------------------------------------------------
/// @name Triggers
///--------------------------------------------------------------------
- (void)proximityManager:(KTKProximityManager *)manager
       didExecuteTrigger:(KTKTrigger * _Nullable)trigger
                   error:(NSError * _Nullable)error;

- (void)proximityManager:(KTKProximityManager *)manager
     triggersInitDidFail:(NSError *)error;

- (void)proximityManager:(KTKProximityManager *)manager
     triggersSyncDidFail:(NSError *)error;

#pragma mark - iBeacon Regions
///--------------------------------------------------------------------
/// @name iBeacon Regions
///--------------------------------------------------------------------
- (void)proximityManager:(KTKProximityManager *)manager
    didEnterBeaconRegion:(__kindof KTKBeaconRegion*)region
             withBeacons:(NSArray<CLBeacon *> *)beacons;

- (void)proximityManager:(KTKProximityManager *)manager
     didExitBeaconRegion:(__kindof KTKBeaconRegion*)region;

- (void)proximityManager:(KTKProximityManager *)manager
    didFailMonitoringFor:(__kindof KTKBeaconRegion* _Nullable)region
               withError:(NSError *)error;

#pragma mark - Eddystone Regions
///--------------------------------------------------------------------
/// @name Eddystone Regions
///--------------------------------------------------------------------
- (void)proximityManager:(KTKProximityManager *)manager
 didEnterEddystoneRegion:(__kindof KTKEddystoneRegion*)region
          withEddystones:(NSSet<KTKEddystone *> *)eddystones;

- (void)proximityManager:(KTKProximityManager *)manager
  didExitEddystoneRegion:(__kindof KTKEddystoneRegion*)region;

- (void)proximityManager:(KTKProximityManager *)manager
        didFailDiscovery:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
