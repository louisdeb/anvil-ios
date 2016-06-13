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

+ (BOOL)saveConfiguration:(UIView *)view buttons:(NSArray *)buttons configUser:(NSString *)username configName:(NSString *)name;
+ (BOOL)nameTaken:(PGconn *)conn username:(NSString *)username configName:(NSString *)name;
+ (NSString *)saveScreenshot:(UIView *)view;
+ (BOOL)uploadToServer:(NSString *)path remotePath:(NSString *)remotePath;
+ (PGconn *)connectToDatabase;
+ (void)saveToDatabase:(PGconn *)conn username:(NSString *)username configName:(NSString *)name json:(NSString *)json url:(NSString *)url;
+ (NSString *)convertButtonsToJSON:(NSArray *)buttons;
+ (NSArray *)getButtonsFromJSON:(NSString *)jsonString;
+ (NSArray *)getConfigurations:(NSString *)username;

@end
