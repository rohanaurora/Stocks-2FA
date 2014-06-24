//
//  Stock.m
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import "Stock.h"

@implementation Stock

- (instancetype)initWithSymbol:(NSString *) theSymbol
                     updatedAt:(NSDate *)theDate
                  withAPriceOf:(float) thePrice
              andPreviousClose:(float) thePreviousClose
                 withAChangeOf:(float) theChange
              andPercentChange:(float) theChangePercent
{
    self = [super init];
    if (self) {
        self.stockSymbol = theSymbol;
        self.lastUpdated = theDate;
        self.stockPrice = thePrice;
        self.previousClose = thePreviousClose;
        self.change = theChange;
        self.changePercent = theChangePercent;
    }
    return self;
}

@end
