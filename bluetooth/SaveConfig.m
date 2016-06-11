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
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imgData = UIImagePNGRepresentation(image);
    
    NSString *path = @"/Users/jonomuller/Desktop/screenshot.png";
    NSError *error = nil;
    [imgData writeToFile:path options:NSDataWritingAtomic error:&error];
    if (error) {
        NSLog(@"Write returned error: %@", [error localizedDescription]);
        return NULL;
    }
    NSLog(@"Image saved to %@", path);
    return path;
}

+ (bool)uploadToServer:(NSString *)path {
    return false;
}

+ (bool)saveToDatabase:(NSString *)name filePath:(NSString *)path {
    const char *conninfo = "host=db.doc.ic.ac.uk port=5432 dbname=g1527117_u user=g1527117_u password=pcauqNdppz";
    PGconn *conn = PQconnectdb(conninfo);
    
    if (PQstatus(conn) != CONNECTION_OK) {
        NSLog(@"Connection to database failed: %s", PQerrorMessage(conn));
        return false;
    }
    
    NSLog(@"Connection successful");
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO configurations(username, name, json, img) VALUES ('usr', '%@', 'json', '%@')", name, path];
    const char *const_sql = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    PGresult *result = PQexec(conn, const_sql);
    
    if (PQresultStatus(result) == PGRES_FATAL_ERROR) {
        NSLog(@"Command failed: %s", PQresultErrorMessage(result));
        return false;
    }
    
    // prints table, used for testing
    /*
    int numRows = PQntuples(result);
    int numFields = PQnfields(result);
    for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numFields; j++) {
            NSLog(@"%d %d: %s", i, j, PQgetvalue(result, i, j));
        }
    }
    */
    
    NSLog(@"Data inserted into table successfully");
    return true;
}

@end
