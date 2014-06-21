//
//  AppDelegate.m
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//


#import "AppDelegate.h"
#import "CustomStaticLibrary.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"cf5vpwci5b39089" // app key
                            appSecret:@"xbz9e4l10d4k5w7" // app secret
                            root:kDBRootAppFolder]; // access type
    [DBSession setSharedSession:dbSession];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];   
    
    vc = [[StocksTableViewController alloc] init];
    
    CustomStaticLibrary *customLibrary = [[CustomStaticLibrary alloc] init];
    vc.title = [customLibrary getMeTheTitle];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navigation;
    
    [self createEditableCopyOfDatabaseIfNeeded];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
            [vc downloadFile];
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"userLocation.db"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"userLocation.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


@end
