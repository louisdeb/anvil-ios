//
//  SaveConfig.m
//  bluetooth
//
//  Created by Jono Muller on 07/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

#import "SaveConfig.h"

@implementation SaveConfig

+ (NSString *)saveScreenshot:(UIView *)view {
    NSLog(@"%@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imgData = UIImagePNGRepresentation(image);
    
    if(imgData) {
        NSString *path = @"/Users/jonomuller/Desktop/screenshot.png";
        NSError *error = nil;
        [imgData writeToFile:path options:NSDataWritingAtomic error:&error];
        if (error)
            NSLog(@"Write returned error: %@", [error localizedDescription]);
        NSLog(@"Image saved to %@", path);
        return path;
    } else {
        NSLog(@"Error while taking screenshot");
        return NULL;
    }
}

+ (bool)saveToServer:(NSString *)path {
    return false;
}

@end
