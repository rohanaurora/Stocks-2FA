//
//  StocksTableViewCell.h
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"

@interface StockTableViewCell : UITableViewCell

-(void) drawMyCell:(Stock *) theStock;

@end
