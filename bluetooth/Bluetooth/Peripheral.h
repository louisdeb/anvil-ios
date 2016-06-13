#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Peripheral : NSObject

@property(nonatomic, strong) NSString *serviceName;
@property(nonatomic, strong) CBUUID *defaultServiceUUID;
@property(nonatomic, strong) CBUUID *readyCUUID;
@property(nonatomic, strong) CBUUID *keyServiceUUID;

- (id)initWithUsername:(NSString *)username;
- (void)startAdvertising;
- (void)addKeyService:(NSMutableArray<NSNumber *> *)keyCodes;
- (void)keyPress:(NSNumber *)key state:(Boolean)state;
- (void)stopAdvertising;

@end
