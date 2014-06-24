//
//  Stock.h
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stock : NSObject

@property (nonatomic, copy) NSString *stockSymbol;
@property (nonatomic, copy) NSDate *lastUpdated;
@property (nonatomic, assign) float stockPrice;
@property (nonatomic, assign) float previousClose;
@property (nonatomic, assign) float change;
@property (nonatomic, assign) float changePercent;

- (instancetype)initWithSymbol:(NSString *)theSymbol
                     updatedAt:(NSDate *)theDate
                  withAPriceOf:(float) thePrice
              andPreviousClose:(float) thePreviousClose
                 withAChangeOf:(float) theChange
              andPercentChange:(float) theChangePercent;

@end