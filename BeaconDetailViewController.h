//
//  BeaconDetailViewController.h
//  BeaconDemo2
//
//  Created by CottrellMACW7u on 2/16/15.
//  Copyright (c) 2015 CottrellMACW7u. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeaconManager.h"

@interface BeaconDetailViewController : UIViewController

@property (nonatomic, strong)   ESTBeacon           *beacon;
@property (nonatomic, strong)   ESTBeaconManager    *beaconManager;
@property (nonatomic, strong)   ESTBeaconRegion     *beaconRegion;

@end
