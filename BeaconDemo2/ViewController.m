//
//  ViewController.m
//  BeaconDemo2
//
//  Created by CottrellMACW7u on 2/7/15.
//  Copyright (c) 2015 CottrellMACW7u. All rights reserved.
//

#import "ViewController.h"
#import "ESTBeaconManager.h"
#import "BeaconDetailViewController.h"

@interface ViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong)   ESTBeacon           *beacon;
@property (nonatomic, strong)   ESTBeaconManager    *beaconManager;
@property (nonatomic, strong)   ESTBeaconRegion     *beaconRegion;
@property (nonatomic, strong)   NSMutableArray      *beaconArray;
@property (weak, nonatomic) IBOutlet UITableView    *tableView;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /////////////////////////////////////////////////////////////
    // setup Estimote beacon manager
    
    // create manager instance and set delegate
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // New iOS 8 request for Always Authorization, required for iBeacons to work!
    if([self.beaconManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.beaconManager requestAlwaysAuthorization];
    }
    
    // create sample region object (you can additionally pass major / minor values)
    // major/minor values available for beacon account at clous.estimote.com
    // you'll need to put your specific major/minor in here
//    ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
//                                                                 major:33534
//                                                                 minor:28888
//                                                            identifier:@"RegionIdentifier"];
//    region.notifyOnEntry = YES;
//    region.notifyOnExit = YES;
    
//    _beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"RegionIdentifier"];
    
    _beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID major:33534 minor:28888 identifier:@"RegionIdentifier"];
    
    // speeds up notifications: see http://developer.radiusnetworks.com/2013/11/13/ibeacon-monitoring-in-the-background-and-foreground.html
    // for full explaination
//    region.notifyEntryStateOnDisplay = YES;
    
    // start looking for Estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    
    _beaconRegion.notifyEntryStateOnDisplay = YES;
    _beaconRegion.notifyOnEntry = YES;
    _beaconRegion.notifyOnExit = YES;
    [self.beaconManager startRangingBeaconsInRegion:_beaconRegion];

    _beaconArray = [[NSMutableArray alloc] init];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;

    self.navigationItem.title = @"Estimote Beacon Demo";
}


#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Monitoring error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [errorView show];
}


- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    NSLog(@"ENTER: %@", region.identifier);
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Enter region notification";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
   // _statusLabel.text = @"Status: ENTER";
}


- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    NSLog(@"EXIT: %@", region.identifier);
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Exit region notification";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
   // _statusLabel.text = @"Status: EXIT";
    
}


-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    if([beacons count] > 0)
    {
        for (ESTBeacon* beacon in beacons) {
            
            NSString *proximityString;
            
            switch (beacon.proximity) {
                case CLProximityUnknown:
                    proximityString = @"Unknown";
                    break;
                case CLProximityImmediate:
                    proximityString = @"Immediate";
                    break;
                case CLProximityNear:
                    proximityString = @"Near";
                    break;
                case CLProximityFar:
                    proximityString = @"Far";
                    break;
                default:
                    break;
            }
            
            [_beaconArray removeAllObjects];
            for (ESTBeacon *beacon in beacons) {
                
                [_beaconArray addObject:beacon];
            }

            [_beaconArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
            [_tableView reloadData];
        }
    }
}
                     

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_beaconArray count];
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellLabel;
    static NSString *simpleTableIdentifier = @"BeaconTableCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    ESTBeacon *beacon = _beaconArray[indexPath.row];
    

    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    [label setText: beacon.name];

    UIImageView  *imageView = (UIImageView*)[cell.contentView viewWithTag:20];
    if (beacon.rssi < -85 || beacon.rssi == 0) {
        [imageView setImage:[UIImage imageNamed:@"signal_stren_25.png"]];
    } else if (beacon.rssi < -70) {
        [imageView setImage:[UIImage imageNamed:@"signal_stren_50.png"]];
    } else if (beacon.rssi < -50 ) {
        [imageView setImage:[UIImage imageNamed:@"signal_stren_75.png"]];
    } else {
        [imageView setImage:[UIImage imageNamed:@"signal_stren_100.png"]];
        
    }
    
    UILabel *rssiLabel = (UILabel *)[cell.contentView viewWithTag:30];
    [rssiLabel setText: [NSString stringWithFormat:@"%ld", (long)beacon.rssi]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:@"beacon_detail_segue" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([sender isKindOfClass:[UIButton class]]) return;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (indexPath.row == 5) {
        
        return;
        
        // Nothing to do
        
    } else {
        BeaconDetailViewController *destViewController = segue.destinationViewController;
        destViewController.beacon = [_beaconArray objectAtIndex:(int)indexPath.row];
        destViewController.beaconRegion = _beaconRegion;
        destViewController.beaconManager = _beaconManager;
    }
}


#pragma mark - Networking

-(void)postStatus:(NSString*)statusString {
    
    // Create your request string with parameter name as defined in PHP file
    NSString *myRequestString = [NSString stringWithFormat:@"status=%@", statusString];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://69.164.201.31/beacon.php"]];
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@",response);
}






@end
