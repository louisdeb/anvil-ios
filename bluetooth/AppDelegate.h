//
//  AppDelegate.h
//  bluetooth
//
//  Created by Louis de Beaumont on 19/05/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SSKeychain.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)addKeyService:(NSMutableArray<NSString *> *)codes;
- (void)keyPress:(NSString *)letter state:(Boolean)state;
- (void)startBluetooth;

@end

