#import <Foundation/Foundation.h>
#import "Peripheral.h"
@import CoreBluetooth;
@import UIKit;

@interface Peripheral () <CBPeripheralManagerDelegate>

@property(nonatomic, strong) CBPeripheralManager *peripheralManager;
@property(nonatomic, strong) CBMutableCharacteristic *characteristic;
@property(nonatomic, strong) CBMutableService *service;


@end

@implementation Peripheral

static NSString *const SERVICE_NAME = @"iPhone App - group 17";
static NSString *const SERVICE_UUID_STRING = @"C93FC016-11E3-4FF2-9CE1-D559AD8828F7";
static NSString *const CHARACTERISTIC_UUID_STRING = @"27B8CD56-0496-498B-AEE9-B746E9F74225";

- (id)init {
  NSLog(@"init Peripheral");
  self = [super init];
  [self setupPeripheral];
  return self;
}

- (void)setupPeripheral {
  _serviceName = SERVICE_NAME;
  _serviceUUID = [CBUUID UUIDWithString:SERVICE_UUID_STRING];
  _characteristicUUID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID_STRING];
  
  _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
  
  _characteristic = [[CBMutableCharacteristic alloc] initWithType:_characteristicUUID
                                                     properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify
                                                     value:nil
                                                     permissions:CBAttributePermissionsReadable];
  
  _service = [[CBMutableService alloc] initWithType:_serviceUUID primary:YES];
  _service.characteristics = @[_characteristic];

  
  NSLog(@"Peripheral set up");
}

/* Start advertising */
- (void)startAdvertising {
  NSLog(@"Starting advertising...");
  
  NSDictionary *advertisment = @{
                                 CBAdvertisementDataServiceUUIDsKey : @[self.serviceUUID],
                                 CBAdvertisementDataLocalNameKey: self.serviceName
                                 };
    [self addServices];
  [self.peripheralManager startAdvertising:advertisment];
}

/* Adds any services we would like to advertise */
- (void) addServices {
    [_peripheralManager addService:_service];
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
  //[_peripheralManager addService:_service];
}

/* Did subscribe to characteristic */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
        didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
  NSLog(@"Central subscribed to a characteristic");
}

/* Did receive read request */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
    didReceiveReadRequest:(CBATTRequest *)request {
  NSLog(@"Did receive read request");
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

@end