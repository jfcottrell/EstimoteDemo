//
//  BeaconDetailViewController.m
//  BeaconDemo2
//
//  Created by CottrellMACW7u on 2/16/15.
//  Copyright (c) 2015 CottrellMACW7u. All rights reserved.
//

#import "BeaconDetailViewController.h"


@interface BeaconDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel    *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel    *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel    *proximityLabel;
@property (weak, nonatomic) IBOutlet UISwitch   *monitoringSwitch;

@end

@implementation BeaconDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _majorLabel.text = [NSString stringWithFormat:@"%@", _beacon.major];
    _minorLabel.text = [NSString stringWithFormat:@"%@", _beacon.minor];
    
    switch (_beacon.proximity) {
        case CLProximityUnknown:
            _proximityLabel.text = @"Unknown";
            break;
        case CLProximityImmediate:
            _proximityLabel.text = @"Immediate";
            break;
        case CLProximityNear:
            _proximityLabel.text = @"Near";
            break;
        case CLProximityFar:
            _proximityLabel.text = @"Far";
            break;
        default:
            break;
    }
    [_monitoringSwitch setOn:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cloudSwitchChanged:(UISwitch*)sender {
    
    if (sender.isOn) {
        
    } else {
        
    }
}


- (IBAction)monitoringSwitchChanged:(UISwitch*)sender {
    
    if (sender.isOn) {
        
        NSLog(@"Monitoring on");
        [_beaconManager startMonitoringForRegion:_beaconRegion];
        
    } else {
        
        NSLog(@"Monitoring off");
        [_beaconManager stopMonitoringForRegion:_beaconRegion];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
