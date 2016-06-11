#import "AppDelegate.h"
#import "Bluetooth/Peripheral.h"

@interface AppDelegate ()

@property(nonatomic, strong) Peripheral *peripheral;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Creating peripheral");
  self.peripheral = [[Peripheral alloc] init];
  
  return YES;
}

- (void)addKeyService:(NSMutableArray<NSNumber *> *)keyCodes {
  [_peripheral addKeyService:keyCodes];
}

- (void)keyPress:(NSString *)letter state:(Boolean)state {
  NSNumber *key = [self getKeyCodeFromString:letter];
  [_peripheral keyPress:key state:state];
}

- (NSNumber *)getKeyCodeFromString:(NSString *)letter {
  if([letter isEqual: @"a"]) {
    return [NSNumber numberWithInt:0];
  } else if([letter isEqual: @"b"]) {
    return [NSNumber numberWithInt:11];
  } else if([letter isEqual: @"c"]) {
    return [NSNumber numberWithInt:8];
  } else if([letter isEqual: @"d"]) {
    return [NSNumber numberWithInt:2];
  } else if([letter isEqual: @"e"]) {
    return [NSNumber numberWithInt:14];
  } else if([letter isEqual: @"f"]) {
    return [NSNumber numberWithInt:3];
  } else if([letter isEqual: @"m"]) {
    return [NSNumber numberWithInt:46];
  } else if([letter isEqual: @"q"]) {
    return [NSNumber numberWithInt:12];
  } else if([letter isEqual: @"s"]) {
    return [NSNumber numberWithInt:1];
  } else if([letter isEqual: @"w"]) {
    return [NSNumber numberWithInt:13];
  } else if([letter isEqual: @"SPACE"]) {
    return [NSNumber numberWithInt:49];
  } else if([letter isEqual: @"LEFT"]) {
    return [NSNumber numberWithInt:123];
  } else if([letter isEqual: @"RIGHT"]) {
    return [NSNumber numberWithInt:124];
  } else if([letter isEqual: @"DOWN"]) {
    return [NSNumber numberWithInt:125];
  } else if([letter isEqual: @"UP"]) {
    return [NSNumber numberWithInt:126];
  }
  
  return [NSNumber numberWithInt:-1];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
