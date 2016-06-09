//
//  SaveConfig.m
//  bluetooth
//
//  Created by Jono Muller on 07/06/2016.
//  Copyright © 2016 webapps. All rights reserved.
//

#import "SaveConfig.h"

@implementation SaveConfig

NSString *password = @"Anvil4lyfe";

- (NSString *)saveScreenshot:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imgData = UIImagePNGRepresentation(image);
    
    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"screenshot.png"];
    
    NSLog(@"Documents directory: %@", [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[paths objectAtIndex:0] error:&error]);
    
    [imgData writeToFile:path options:NSDataWritingAtomic error:&error];
    if (error) {
        NSLog(@"Write returned error: %@", [error localizedDescription]);
        return NULL;
    }
    NSLog(@"Image saved to %@", path);
    [self uploadToServer:path];
    return path;
}

- (void)uploadToServer:(NSString *)path {
    NMSSHSession *session = [NMSSHSession connectToHost:@"shell1.doc.ic.ac.uk"
                                           withUsername:@"jam614"];
    
    if (session.isConnected) {
        [session authenticateByPassword:password];
        
        if (session.isAuthorized) {
            NSLog(@"Authentication succeeded");
        }
    }
    
    bool success = [session.channel uploadFile:path to:@"/vol/project/2015/271/g1527117/configs/"];
    [session disconnect];
    
    if (success) {
        NSString *url = @"https://www.doc.ic.ac.uk/project/2015/271/g1527117/configs/screenshot.png";
        [self saveToDatabase:@"test name" url:url];
    }
}

- (void)saveToDatabase:(NSString *)name url:(NSString *)url {
    const char *conninfo = "host=db.doc.ic.ac.uk port=5432 dbname=g1527117_u user=g1527117_u password=pcauqNdppz";
    PGconn *conn = PQconnectdb(conninfo);
    
    if (PQstatus(conn) != CONNECTION_OK) {
        NSLog(@"Connection to database failed: %s", PQerrorMessage(conn));
    }
    
    NSLog(@"Connection successful");
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO configurations(username, name, json, img) VALUES ('jonomuller', '%@', 'json', '%@')", name, url];
    const char *const_sql = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    PGresult *result = PQexec(conn, const_sql);
    
    if (PQresultStatus(result) == PGRES_FATAL_ERROR) {
        NSLog(@"Command failed: %s", PQresultErrorMessage(result));
    }
    
    NSLog(@"Data inserted into table successfully");
}

@end
