//
//  AppDelegate.h
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "StocksTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    StocksTableViewController *vc;
}

@property (strong, nonatomic) UIWindow *window;

@end

