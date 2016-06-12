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

+ (BOOL)saveConfiguration:(UIView *)view configUser:(NSString *)username configName:(NSString *)name {
    const char *conninfo = "host=db.doc.ic.ac.uk port=5432 dbname=g1527117_u user=g1527117_u password=pcauqNdppz";
    PGconn *conn = PQconnectdb(conninfo);
    
    if ([self nameTaken:conn username:username configName:name]) {
        return NO;
    }
    
    NSString *path = [self saveScreenshot:view];
    BOOL uploaded = false;
    
    if (path) {
        NSString *remotePath = [NSString stringWithFormat:@"/vol/project/2015/271/g1527117/configs/%@-%@.png", username, name];
        uploaded = [self uploadToServer:path remotePath:remotePath];
    }
    
    if (uploaded) {
        NSString *urlName = [name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *url = [NSString stringWithFormat:@"https://www.doc.ic.ac.uk/project/2015/271/g1527117/configs/%@-%@.png", username, urlName];
        [self saveToDatabase:conn username:username configName:name url:url];
    }
    
    return YES;
}

+ (BOOL)nameTaken:(PGconn *)conn username:(NSString *)username configName:(NSString *)name {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM configurations WHERE username='%@' and name='%@'", username, name];
    const char *const_sql = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    PGresult *result = PQexec(conn, const_sql);
    int numRows = PQntuples(result);
    
    if (numRows > 0) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)saveScreenshot:(UIView *)view {
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
    return path;
}

+ (BOOL)uploadToServer:(NSString *)path remotePath:(NSString *)remotePath {
    NMSSHSession *session = [NMSSHSession connectToHost:@"shell1.doc.ic.ac.uk"
                                           withUsername:@"jam614"];
    
    if (session.isConnected) {
        [session authenticateByPassword:password];
        
        if (session.isAuthorized) {
            NSLog(@"Authentication succeeded");
        }
    }
    
    bool success = [session.channel uploadFile:path to:remotePath];
    [session disconnect];
    
    return success;
}

+ (void)saveToDatabase:(PGconn *)conn username:(NSString *)username configName:(NSString *)name url:(NSString *)url {
    if (PQstatus(conn) != CONNECTION_OK) {
        NSLog(@"Connection to database failed: %s", PQerrorMessage(conn));
    }
    
    NSLog(@"Connection successful");
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO configurations(username, name, json, img, numfavs) VALUES ('%@', '%@', 'json', '%@', '0')", username, name, url];
    const char *const_sql = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    PGresult *result = PQexec(conn, const_sql);
    
    if (PQresultStatus(result) == PGRES_FATAL_ERROR) {
        NSLog(@"Command failed: %s", PQresultErrorMessage(result));
    }
    
    NSLog(@"Data inserted into table successfully");
}

@end
