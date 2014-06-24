//
//  Database.h
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

//Database Schema
//sqlite> .schema
//CREATE TABLE userLocation (stockId INTEGER PRIMARY KEY, stockSymbol text, lastUpdated text, price real, previousClose real, change real, changePercent real, userLatitude real, userLongitude real);

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Stock.h"

@interface Database : NSObject {
    sqlite3 *database;
}

+(Database *)database;

-(void) addANewEntryOrUpdate:(Stock *) theStock withUserLat:(float) userLatitude andLong:(float) userLongitude;

@end
