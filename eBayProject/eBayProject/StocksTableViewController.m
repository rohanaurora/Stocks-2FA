//
//  StocksTableViewController.m
//  eBayProject
//
//  Created by Rohan Aurora on 6/20/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import "StocksTableViewController.h"

@interface StocksTableViewController () {
    NSMutableArray *stockObjects;
    float userLatitude;
    float userLongitude;
}

@end

@implementation StocksTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    clManager = [CLLocationManager new];
    [clManager setDelegate:self];
    [clManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [clManager startUpdatingLocation];
    
    
    stockObjects = [[NSMutableArray alloc] init];
    [self.tableView registerClass:[StockTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self serializeDataFromLocalPath];
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    else {
        [self downloadFile];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [stockObjects count];
}

-(void) downloadFile {
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    [self.restClient loadMetadata:@"/"];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell drawMyCell:[stockObjects objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void) serializeDataFromLocalPath {
    
    NSString *localPath = [self getLocalPath];
    
    BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:localPath];
    
    if (success) {
        
        
        NSData *jsonData = [NSData dataWithContentsOfFile:localPath];
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        
        for(NSDictionary *theStockDict in [jsonDict objectForKey:@"stocks"]) {
            NSString *symbol = [theStockDict objectForKey:@"t"];
            NSString *dateString = [theStockDict objectForKey:@"lt_dts"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            NSDate *date = [dateFormat dateFromString:dateString];
            float price = [[theStockDict objectForKey:@"l"] floatValue];
            float previousClose = [[theStockDict objectForKey:@"pcls_fix"] floatValue];
            float change = [[theStockDict objectForKey:@"c"] floatValue];
            float changePercent = [[theStockDict objectForKey:@"cp"] floatValue];
            
            Stock *theStock = [[Stock alloc] initWithSymbol:symbol updatedAt:date withAPriceOf:price andPreviousClose:previousClose withAChangeOf:change andPercentChange:changePercent];
            [stockObjects addObject:theStock];
        }
        
        [self insertDataIntoDatabase];
        [self.tableView reloadData];
        
    }
    
    
}

-(NSString *) getLocalPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cahceDirectory = [paths objectAtIndex:0];
    return [cahceDirectory stringByAppendingPathComponent:@"stocks.json"];
    
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
            if([file.filename isEqualToString:@"stocks.json"]) {
                NSString *localPath = [self getLocalPath];
                [self.restClient loadFile:file.path intoPath:localPath];
                [self performSelector:@selector(serializeDataFromLocalPath) withObject:nil afterDelay:2.0];
            }
        }
    }
}


- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations {
    
    [clManager stopUpdatingLocation];
    
    CLLocation *userLocation = [locations firstObject];
    userLatitude = userLocation.coordinate.latitude;
    userLongitude = userLocation.coordinate.longitude;
    [self insertDataIntoDatabase];
    
}

-(void) insertDataIntoDatabase {
    if([stockObjects count] > 0) {
        if(userLatitude != 0) {
            for(Stock *theStock in stockObjects) {
                [[Database database] addANewEntryOrUpdate:theStock withUserLat:userLatitude andLong:userLongitude];
            }
        }
    }
    
}

@end