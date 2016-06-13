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

+ (BOOL)saveConfiguration:(UIView *)view buttons:(NSDictionary *)buttons configUser:(NSString *)username configName:(NSString *)name {
    PGconn *conn = [self connectToDatabase];
    
    if ([self nameTaken:conn username:username configName:name]) {
        return NO;
    }
    
    for (UIView *subView in [view subviews]) {
        if ([[subView restorationIdentifier] isEqualToString:@"saveButton"] || [[subView restorationIdentifier] isEqualToString:@"elementsButton"]) {
            [subView removeFromSuperview];
        }
    }
    
    NSString *path = [self saveScreenshot:view];
    BOOL uploaded = false;
    
    if (path) {
        NSString *remotePath = [NSString stringWithFormat:@"/vol/project/2015/271/g1527117/configs/%@-%@.png", username, name];
        uploaded = [self uploadToServer:path remotePath:remotePath];
    }
    
    NSString *json = [self convertButtonsToJSON:buttons];
    
    if (uploaded) {
        NSString *urlName = [name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *url = [NSString stringWithFormat:@"https://www.doc.ic.ac.uk/project/2015/271/g1527117/configs/%@-%@.png", username, urlName];
        [self saveToDatabase:conn username:username configName:name json:json url:url];
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

+ (void)saveToDatabase:(PGconn *)conn username:(NSString *)username configName:(NSString *)name json:(NSString *)json url:(NSString *)url {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO configurations(username, name, json, img, numfavs) VALUES ('%@', '%@', '%@', '%@', '0')", username, name, json, url];
    const char *const_sql = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    PGresult *result = PQexec(conn, const_sql);
    
    if (PQresultStatus(result) == PGRES_FATAL_ERROR) {
        NSLog(@"Command failed: %s", PQresultErrorMessage(result));
    }
    
    NSLog(@"Data inserted into table successfully");
}

+ (PGconn *)connectToDatabase {
    const char *conninfo = "host=db.doc.ic.ac.uk port=5432 dbname=g1527117_u user=g1527117_u password=pcauqNdppz";
    PGconn *conn = PQconnectdb(conninfo);
    NSLog(@"Connection successful");
    if (PQstatus(conn) != CONNECTION_OK) {
        NSLog(@"Connection to database failed: %s", PQerrorMessage(conn));
    }
    return conn;
}

+ (NSString *)convertButtonsToJSON:(NSDictionary *)buttons {
    NSMutableArray *viewsData = [[NSMutableArray alloc] init];
    NSMutableDictionary *viewsDict = [[NSMutableDictionary alloc] init];
    NSString *viewData;
    
    for (UIView *view in buttons) {
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver  *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:view forKey:@"view"];
        [archiver finishEncoding];
        viewData = [data base64EncodedStringWithOptions:kNilOptions];
        NSString *key = [buttons objectForKey:view];
        [viewsDict setObject:viewData forKey:@"data"];
        [viewsDict setObject:key forKey:@"key"];
        [viewsData addObject:[viewsDict copy]];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:viewsData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSArray *)getButtonsFromJSON:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *viewsData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    NSMutableArray *mappings = [[NSMutableArray alloc] init];
    NSData *data;
    
    for (NSDictionary *viewDict in viewsData) {
        NSString *viewData = [viewDict objectForKey:@"data"];
        data = [[NSData alloc] initWithBase64EncodedString:viewData options:kNilOptions];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        UIView *view = [unarchiver decodeObjectForKey:@"view"];
        [unarchiver finishDecoding];
        NSString *key = [viewDict objectForKey:@"key"];
        [buttons addObject:view];
        [mappings addObject:key];
    }
    
    NSArray *controller = [NSArray arrayWithObjects:buttons, mappings, nil];
    
    return controller;
}

+ (NSArray *)getConfigurations:(NSString *)username {
    PGconn *conn = [self connectToDatabase];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM configurations WHERE username='%@'", username];
    const char *const_sql = [sql cStringUsingEncoding:NSASCIIStringEncoding];
    PGresult *result = PQexec(conn, const_sql);
    
    NSMutableArray *configs = [[NSMutableArray alloc] init];
    
    int numRows = PQntuples(result);
    int numColumns = PQnfields(result);
    for (int i = 0; i < numRows; i++) {
        NSDictionary *dictionary = [[NSMutableDictionary alloc] init];
        for (int j = 0; j < numColumns - 2; j++) {
            char *name = PQfname(result, j);
            char *data = PQgetvalue(result, i, j);
            NSString *key = [NSString stringWithUTF8String:name];
            NSString *value = [NSString stringWithUTF8String:data];
            [dictionary setValue:value forKey:key];
            
            if (j == numColumns - 3) {
                [configs addObject:dictionary];
            }
        }
    }
    
    return configs;
}

@end
