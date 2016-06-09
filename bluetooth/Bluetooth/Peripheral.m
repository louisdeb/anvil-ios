#import <Foundation/Foundation.h>
#import "Peripheral.h"
@import CoreBluetooth;
@import UIKit;

@interface Peripheral () <CBPeripheralManagerDelegate>

@property(nonatomic, strong) CBPeripheralManager *peripheralManager;
@property(nonatomic, strong) CBMutableCharacteristic *readyCharacteristic;
@property(nonatomic, strong) CBMutableService *defaultService;
@property(nonatomic, strong) CBMutableService *keyService;

@end

@implementation Peripheral

static NSString *SERVICE_NAME;
static NSString *const SERVICE_UUID_STRING = @"C93FC016-11E3-4FF2-9CE1-D559AD8828F7";
static NSString *const READY_CUUID = @"27B8CD56-0496-498B-AEE9-B746E9F74225";
static NSString *const KEY_SERVICE_UUID_STRING = @"A74EDFB7-10CA-4711-AA86-308FD7E29E59";

NSMutableDictionary *keyToUuidDict;

- (id)init {
  NSLog(@"init Peripheral");
  SERVICE_NAME = [[UIDevice currentDevice] name];
  self = [super init];
  [self setupPeripheral];
  return self;
}

- (void)setupPeripheral {
  _serviceName = SERVICE_NAME;
  _defaultServiceUUID = [CBUUID UUIDWithString:SERVICE_UUID_STRING];
  _readyCUUID = [CBUUID UUIDWithString:READY_CUUID];
  
  _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
  
  _readyCharacteristic = [[CBMutableCharacteristic alloc] initWithType:_readyCUUID
                                                     properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify
                                                     value:nil
                                                     permissions:CBAttributePermissionsReadable];
  
  _defaultService = [[CBMutableService alloc] initWithType:_defaultServiceUUID primary:YES];
  _defaultService.characteristics = @[_readyCharacteristic];
  
  NSLog(@"Peripheral set up");
}

/* Add our default service and start advertising. */
- (void)startAdvertising {
  NSDictionary *advertisment = @{
                                 CBAdvertisementDataServiceUUIDsKey : @[self.defaultServiceUUID],
                                 CBAdvertisementDataLocalNameKey: self.serviceName
                                 };
  [_peripheralManager addService:_defaultService];
  [self.peripheralManager startAdvertising:advertisment];
}

/* Did update state */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
  switch (peripheral.state) {
    case CBPeripheralManagerStatePoweredOn:
      NSLog(@"peripheralStateChange: Powered On");
      // When the bluetooth has turned on, start advertising.
      [self startAdvertising];
      break;
    case CBPeripheralManagerStatePoweredOff: {
      NSLog(@"peripheralStateChange: Powered Off");
      break;
    }
    case CBPeripheralManagerStateResetting: {
      NSLog(@"peripheralStateChange: Resetting");
      break;
    }
    case CBPeripheralManagerStateUnauthorized: {
      NSLog(@"peripheralStateChange: Deauthorized");
      break;
    }
    case CBPeripheralManagerStateUnsupported: {
      NSLog(@"peripheralStateChange: Unsupported");
      break;
    }
    case CBPeripheralManagerStateUnknown:
      NSLog(@"peripheralStateChange: Unknown");
      break;
    default:
      break;
  }
}

/* Did add service */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {
  NSLog(@"Did add service");
  NSLog(@"with %lu characteristics", [service.characteristics count]);
  NSLog(@"%@", service.UUID);
  if (error) {
    NSLog(@"Error in adding service: %@", [error localizedDescription]);
    NSLog(@"UUID: %@", service.UUID);
  }
}

/* Did start advertising */
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {
  NSLog(@"Did start advertising");
}

/* Did subscribe to characteristic */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
        didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
  NSLog(@"Central subscribed to a characteristic");
  if(characteristic == _readyCharacteristic) {
    NSLog(@"Subscribed to ready characteristic");
    // Produce screen to select controller
    [self addKeyService:@[@2, @4, @10]];
    [self setReady];
  }
}

/* Update and set readyCharacteristic to let OSX know we have added
   the configuration service and characteristics. */
- (void)setReady {
  NSString* msg = @"Timan is a derkhead";
  NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
  [self.peripheralManager updateValue:data forCharacteristic:_readyCharacteristic onSubscribedCentrals:nil];
  [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_readyCharacteristic onSubscribedCentrals:nil];
}

//  NSString* str = @"Y";
//  NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
//  [self.peripheralManager updateValue:data forCharacteristic:_characteristic onSubscribedCentrals:nil];
//  [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_characteristic onSubscribedCentrals:nil];

/* Did receive read request */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
    didReceiveReadRequest:(CBATTRequest *)request {
  NSLog(@"Did receive read request");
  [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
}

/* Did receive write request */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
  didReceiveWriteRequests:(NSArray *)requests {
  NSLog(@"Did receive write request");
}

/* Did discover services */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  NSLog(@"Did discover services");
}

- (void)addKeyService:(NSMutableArray<NSNumber *> *)keyCodes {
  NSLog(@"Adding service");
  /* Set up service. */
  _keyServiceUUID = [CBUUID UUIDWithString:KEY_SERVICE_UUID_STRING];
  _keyService = [[CBMutableService alloc] initWithType:_keyServiceUUID primary:YES];
  
  /* Add characteristics to service. */
  NSArray *chars = [self addKeyCharacteristics:keyCodes];
  _keyService.characteristics = chars;
  
  [_peripheralManager addService:_keyService];
  NSLog(@"Finished adding service");
}


- (NSArray<CBMutableCharacteristic *> *)addKeyCharacteristics:(NSMutableArray<NSNumber *> *)keyCodes {
  keyToUuidDict = [[NSMutableDictionary alloc] init];
  NSMutableArray<CBMutableCharacteristic *> *characteristics = [[NSMutableArray alloc] init];
  for(NSNumber *key in keyCodes) {
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    CBUUID *uuid = [CBUUID UUIDWithString:uuidString];
    CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:uuid properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    [characteristics addObject:characteristic];
    [keyToUuidDict setObject:characteristic forKey:key];
  }
  NSArray *result = [characteristics copy];
  return result;
}

@end