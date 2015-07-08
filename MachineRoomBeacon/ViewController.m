//
//  ViewController.m
//  MachineRoomBeacon
//
//  Created by Marc-Alexandre GHALY on 06/03/15.
//  Copyright (c) 2015 Marc-Alexandre GHALY. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ESTBeaconManager.h"

@interface ViewController ()

@property (nonatomic, strong) ESTBeacon *beacon;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *beaconRegion;

@end
@implementation ViewController

@synthesize RangeLabel, NumberLabel, Minlabel, HourLabel;

static int s;
static int min;
static int hour;


- (void)viewDidLoad {
    [super viewDidLoad];


    //Enter your beacon UUID
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    //set up beacon manager
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    //set up beacon region
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid
                                                                 major:94
                                                                 minor:15
                                                            identifier:@"RedionIdentifier" ];

    //let us know when exit and enter
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    //start monitoring
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    
    //start ranging
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    
    //Asks to monitor in background - iOS 8
    [self.beaconManager requestAlwaysAuthorization];

  
}

//check region failure
-(void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error{
    NSLog(@"Region did fail: Manager : %@ - Region : %@ - Error : %@ ", manager, region, error);
}

//check permission status
-(void)beaconManager:(ESTBeaconManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Status %d", status);
}


-(void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"A beacon is in range";
    notification.soundName = @"Default.mp3";
    
    NSLog(@"A beacon is in range");
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"A beacon has exited";
    notification.soundName = @"Default.mp3";
    
    NSLog(@"A beacon has exited");
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {

    if (beacons.count > 0) {
        ESTBeacon *firstBeacon = [beacons firstObject];
        self.RangeLabel.text = [self textForProximity:firstBeacon.proximity];
        NSString *prox = [self textForProximity:firstBeacon.proximity];
        
        if ([prox  isEqual: @"Near"] || [prox isEqual:@"Immediate"] )
            s = s + 1;

        self.NumberLabel.text = [NSString stringWithFormat:@"Present for %d second(s)", s];
        
       	self.Minlabel.text = [NSString stringWithFormat:@"Present for %d minute(s)", min];
        
        self.HourLabel.text = [NSString stringWithFormat:@"Present for %d hour(s)", hour];

        if (s >= 60)
        {
        	min += 1;
        	s = 0;
        	if (min >= 60)
        	{
        		hour += 1;
        		min = 0;
        	}
        }
    }
    
}

-(NSString *)textForProximity: (CLProximity)proximity {

    switch (proximity) {
        case CLProximityFar:
            NSLog(@"Far");
            return @"Far";
            break;
            
        case CLProximityNear:
            NSLog(@"Near");
            self.RangeLabel.textColor = [UIColor purpleColor];
            return @"Near";
            break;
        
        case CLProximityImmediate:
            NSLog(@"Immediate");
            self.RangeLabel.textColor = [UIColor redColor];
            
            return @"Immediate";
            break;
            
        case CLProximityUnknown:
            NSLog(@"Unknown");
            return @"Unknown";
            break;
            
        default:
            break;
    }
    
}

/*************************************************************************/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
