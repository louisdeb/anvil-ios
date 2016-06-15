#import "AppDelegate.h"
#import "Bluetooth/Peripheral.h"

@interface AppDelegate ()

@property(nonatomic, strong) Peripheral *peripheral;
@property(nonatomic, strong) NSMutableDictionary *keyCodes;

@end

@implementation AppDelegate

@synthesize keyCodes;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    keyCodes = [[NSMutableDictionary alloc] init];
    [self populateKeyCodeDictionary];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"navController"];
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"initialView"];
    NSArray *accounts = [SSKeychain accountsForService:@"Anvil"];
    
    if ([accounts count] > 0) {
        self.window.rootViewController = viewController;
    } else {
        self.window.rootViewController = navController;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)startBluetooth:(NSString *)username {
  NSLog(@"Creating peripheral");
  self.peripheral = [[Peripheral alloc] initWithUsername:username];
}

- (void)stopBluetooth {
  [self.peripheral stopAdvertising];
}

- (void)addKeyService:(NSMutableArray<NSString *> *)codes {
    NSMutableArray<NSNumber *> *keys = [[NSMutableArray alloc] init];
    for(NSString *s in codes) {
        [keys addObject:[self getKeyCodeFromString:s]];
    }
    [_peripheral addKeyService:keys];
}

- (void)keyPress:(NSString *)letter state:(Boolean)state {
  NSNumber *key = [self getKeyCodeFromString:letter];
  [_peripheral keyPress:key state:state];
}

- (NSNumber *)getKeyCodeFromString:(NSString *)letter {
    return [self.keyCodes objectForKey:letter];
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

- (void)populateKeyCodeDictionary {
    [keyCodes setObject:[NSNumber numberWithInteger:0] forKey:@"A"];
    [keyCodes setObject:[NSNumber numberWithInteger:11] forKey:@"B"];
    [keyCodes setObject:[NSNumber numberWithInteger:8] forKey:@"C"];
    [keyCodes setObject:[NSNumber numberWithInteger:2] forKey:@"D"];
    [keyCodes setObject:[NSNumber numberWithInteger:14] forKey:@"E"];
    [keyCodes setObject:[NSNumber numberWithInteger:3] forKey:@"F"];
    [keyCodes setObject:[NSNumber numberWithInteger:5] forKey:@"G"];
    [keyCodes setObject:[NSNumber numberWithInteger:4] forKey:@"H"];
    [keyCodes setObject:[NSNumber numberWithInteger:34] forKey:@"I"];
    [keyCodes setObject:[NSNumber numberWithInteger:38] forKey:@"J"];
    [keyCodes setObject:[NSNumber numberWithInteger:40] forKey:@"K"];
    [keyCodes setObject:[NSNumber numberWithInteger:37] forKey:@"L"];
    [keyCodes setObject:[NSNumber numberWithInteger:46] forKey:@"M"];
    [keyCodes setObject:[NSNumber numberWithInteger:45] forKey:@"N"];
    [keyCodes setObject:[NSNumber numberWithInteger:31] forKey:@"O"];
    [keyCodes setObject:[NSNumber numberWithInteger:35] forKey:@"P"];
    [keyCodes setObject:[NSNumber numberWithInteger:12] forKey:@"Q"];
    [keyCodes setObject:[NSNumber numberWithInteger:15] forKey:@"R"];
    [keyCodes setObject:[NSNumber numberWithInteger:1] forKey:@"S"];
    [keyCodes setObject:[NSNumber numberWithInteger:17] forKey:@"T"];
    [keyCodes setObject:[NSNumber numberWithInteger:32] forKey:@"U"];
    [keyCodes setObject:[NSNumber numberWithInteger:9] forKey:@"V"];
    [keyCodes setObject:[NSNumber numberWithInteger:13] forKey:@"W"];
    [keyCodes setObject:[NSNumber numberWithInteger:7] forKey:@"X"];
    [keyCodes setObject:[NSNumber numberWithInteger:16] forKey:@"Y"];
    [keyCodes setObject:[NSNumber numberWithInteger:6] forKey:@"Z"];
    [keyCodes setObject:[NSNumber numberWithInteger:126] forKey:@"UP"];
    [keyCodes setObject:[NSNumber numberWithInteger:125] forKey:@"DOWN"];
    [keyCodes setObject:[NSNumber numberWithInteger:123] forKey:@"LEFT"];
    [keyCodes setObject:[NSNumber numberWithInteger:124] forKey:@"RIGHT"];
    [keyCodes setObject:[NSNumber numberWithInteger:18] forKey:@"1"];
    [keyCodes setObject:[NSNumber numberWithInteger:19] forKey:@"2"];
    [keyCodes setObject:[NSNumber numberWithInteger:20] forKey:@"3"];
    [keyCodes setObject:[NSNumber numberWithInteger:21] forKey:@"4"];
    [keyCodes setObject:[NSNumber numberWithInteger:23] forKey:@"5"];
    [keyCodes setObject:[NSNumber numberWithInteger:22] forKey:@"6"];
    [keyCodes setObject:[NSNumber numberWithInteger:26] forKey:@"7"];
    [keyCodes setObject:[NSNumber numberWithInteger:28] forKey:@"8"];
    [keyCodes setObject:[NSNumber numberWithInteger:25] forKey:@"9"];
    [keyCodes setObject:[NSNumber numberWithInteger:29] forKey:@"0"];
    [keyCodes setObject:[NSNumber numberWithInteger:49] forKey:@"SPACE"];
    [keyCodes setObject:[NSNumber numberWithInteger:36] forKey:@"RETURN"];
}

- (NSDictionary *)getKeyCodes {
    return keyCodes;
}

@end
