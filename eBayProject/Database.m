//
//  Database.m
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import "Database.h"

@implementation Database

static Database *database;


+(id) alloc {
    if (database) {
        @throw [NSException exceptionWithName:@"Singleton Vialotaion" reason:@"You are violating the singleton class usage. Please call +sharedInstance method" userInfo:nil];
    }
    else {
        return [super alloc];
    }
}

+(Database *)database {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [[self alloc] init];
    });
    
    return database;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *sqliteDb = [documentsDirectory stringByAppendingPathComponent:@"userLocation.db"];
        
        
        if(sqlite3_open([sqliteDb UTF8String], &database) != SQLITE_OK){
            NSLog(@"Failed to open DB");
        } else {
            NSLog(@"SUCCESS");
        }
        
    }
    return self;
}


-(void) addANewEntryOrUpdate:(Stock *) theStock withUserLat:(float) userLatitude andLong:(float) userLongitude {
    
    const char *sql = "INSERT INTO userLocation (stockSymbol, lastUpdated, price, previousClose, change, changePercent, userLatitude, userLongitude) values (?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
    {
    }
    
    sqlite3_bind_text(statement, 1, [theStock.stockSymbol UTF8String], -1, SQLITE_TRANSIENT);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *stringFromDate = [dateFormat stringFromDate:theStock.lastUpdated];
    
    sqlite3_bind_text(statement, 2, [stringFromDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_double(statement, 3, theStock.stockPrice);
    sqlite3_bind_double(statement, 4, theStock.previousClose);
    sqlite3_bind_double(statement, 5, theStock.change);
    sqlite3_bind_double(statement, 6, theStock.changePercent);
    sqlite3_bind_double(statement, 7, userLatitude);
    sqlite3_bind_double(statement, 8, userLongitude);
    
    
    
    if(SQLITE_DONE != sqlite3_step(statement))
        NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
    sqlite3_finalize(statement);
    
    
    
}

@end
