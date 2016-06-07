//
//  SaveConfig.h
//  bluetooth
//
//  Created by Jono Muller on 07/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
// #import <NMSSH/NMSSH.h>
#import "ViewController.h"

@interface SaveConfig : NSObject

+ (NSString *)saveScreenshot:(UIView *) view;
+ (bool)saveToServer:(NSString *) path;

@end
