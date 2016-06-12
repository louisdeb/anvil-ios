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

+ (BOOL)saveConfiguration:(UIView *)view configUser:(NSString *)username configName:(NSString *)name;
+ (BOOL)nameTaken:(PGconn *)conn username:(NSString *)username configName:(NSString *)name;
+ (NSString *)saveScreenshot:(UIView *)view;
+ (BOOL)uploadToServer:(NSString *)path remotePath:(NSString *)remotePath;
+ (void)saveToDatabase:(PGconn *)conn username:(NSString *)username configName:(NSString *)name url:(NSString *)url;

@end
