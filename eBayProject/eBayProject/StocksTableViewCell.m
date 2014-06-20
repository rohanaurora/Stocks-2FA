//
//  StocksTableViewCell.m
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//


#import "StocksTableViewCell.h"

@interface StockTableViewCell () {
    
    UILabel *stockSymbol;
    UILabel *stockPrice;
    UILabel *stockChange;
    UILabel *stockChangePercent;
    UILabel *stockDate;
    
}

@end

@implementation StockTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        stockSymbol = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        stockSymbol.font = [UIFont boldSystemFontOfSize:18.0];
        stockSymbol.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:stockSymbol];
        
        stockPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        stockPrice.textAlignment = NSTextAlignmentRight;
        stockPrice.font = [UIFont boldSystemFontOfSize:18.0];
        stockPrice.textColor = [UIColor greenColor];
        [self.contentView addSubview:stockPrice];
        
        stockChange = [[UILabel alloc] initWithFrame:CGRectMake(230, 25, 35, 20)];
        stockChange.textAlignment = NSTextAlignmentRight;
        stockChange.font = [UIFont systemFontOfSize:12.0];
        stockChange.textColor = [UIColor greenColor];
        [self.contentView addSubview:stockChange];
        
        stockChangePercent = [[UILabel alloc] initWithFrame:CGRectMake(265, 25, 40, 20)];
        stockChangePercent.textAlignment = NSTextAlignmentRight;
        stockChangePercent.font = [UIFont systemFontOfSize:12.0];
        stockChangePercent.textColor = [UIColor greenColor];
        [self.contentView addSubview:stockChangePercent];
        
        stockDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 200, 20)];
        stockDate.textAlignment = NSTextAlignmentLeft;
        stockDate.font = [UIFont systemFontOfSize:12.0];
        stockDate.textColor = [UIColor blackColor];
        [self.contentView addSubview:stockDate];
        
    }
    return self;
}

-(void) drawMyCell:(Stock *) theStock {
    
    stockSymbol.text = theStock.stockSymbol;
    stockPrice.text = [NSString stringWithFormat:@"%0.2f",theStock.stockPrice];
    stockChange.text = [NSString stringWithFormat:@"%0.2f",theStock.change];
    stockChangePercent.text = [NSString stringWithFormat:@"(%0.2f)",theStock.changePercent];
    
    if(theStock.change < 0){
        stockPrice.textColor = [UIColor redColor];
        stockChange.textColor = [UIColor redColor];
        stockChangePercent.textColor = [UIColor redColor];
    } else {
        stockPrice.textColor = [UIColor greenColor];
        stockChange.textColor = [UIColor greenColor];
        stockChangePercent.textColor = [UIColor greenColor];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    
    NSString *dateString = [dateFormatter stringFromDate:theStock.lastUpdated];
    stockDate.text = dateString;
    
    
}

@end
