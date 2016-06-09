#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Peripheral : NSObject

@property(nonatomic, strong) NSString *serviceName;
@property(nonatomic, strong) CBUUID *serviceUUID;
@property(nonatomic, strong) CBUUID *characteristicUUID;

- (void)startAdvertising;
- (void)addKeyService:(int)keyCode;

@end
