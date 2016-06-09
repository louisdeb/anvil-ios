#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Peripheral : NSObject

@property(nonatomic, strong) NSString *serviceName;
@property(nonatomic, strong) CBUUID *serviceUUID;
@property(nonatomic, strong) CBUUID *characteristicUUID;
@property(nonatomic, strong) CBUUID *keyServiceUUID;

- (void)startAdvertising;
- (void)addKeyService:(NSMutableArray<NSNumber *> *)keyCodes;

@end
