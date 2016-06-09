//
//  SaveConfig.h
//  bluetooth
//
//  Created by Jono Muller on 07/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <libpq/libpq-fe.h>
#import <NMSSH/NMSSH.h>
#import "ViewController.h"

@interface SaveConfig : NSObject

+ (void)saveConfiguration:(UIView *)view configUser:(NSString *)username configName:(NSString *)name;
+ (NSString *)saveScreenshot:(UIView *)view;
+ (bool)uploadToServer:(NSString *)path remotePath:(NSString *)remotePath;
+ (void)saveToDatabase:(NSString *)username configName:(NSString *)name url:(NSString *)url;

@end
