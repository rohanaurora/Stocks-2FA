//
//  StocksTableViewController.h
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "Stock.h"
#import "StocksTableViewCell.h"
#import "Database.h"

@interface StocksTableViewController : UITableViewController <DBRestClientDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager *clManager;
}

@property (nonatomic, strong) DBRestClient *restClient;

-(void) downloadFile;

@end