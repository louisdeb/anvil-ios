#import <Foundation/Foundation.h>
#import "Peripheral.h"
@import CoreBluetooth;

@interface Peripheral () <CBPeripheralManagerDelegate>

@property(nonatomic, strong) CBPeripheralManager *peripheralManager;
@property(nonatomic, strong) CBMutableCharacteristic *characteristic;
@property(nonatomic, strong) CBMutableService *service;


@end

@implementation Peripheral

static NSString *const SERVICE_NAME = @"Peripheral App";
static NSString *const SERVICE_UUID_STRING = @"180F";
static NSString *const CHARACTERISTIC_UUID_STRING = @"2A19";

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
                                                     properties:CBCharacteristicPropertyRead
                                                     value:nil
                                                     permissions:CBAttributePermissionsReadable];
  
  _service = [[CBMutableService alloc] initWithType:_serviceUUID primary:YES];
  _service.characteristics = @[_characteristic];
  
  [_peripheralManager addService:_service];
  
  NSLog(@"Peripheral set up");
}

/* Did update state */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {}


/* Did add service */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {}

/* Did start advertising */
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {}

/* Did subscribe to characteristic */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
        didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {}

/* Did receive read request */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
    didReceiveReadRequest:(CBATTRequest *)request {}

/* Did receive write request */
- (void)peripheralManager:(CBPeripheralManager *)peripheral
  didReceiveWriteRequests:(NSArray *)requests {}


@end