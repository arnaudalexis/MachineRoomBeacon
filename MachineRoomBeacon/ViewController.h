//
//  ViewController.h
//  MachineRoomBeacon
//
//  Created by Marc-Alexandre GHALY on 06/03/15.
//  Copyright (c) 2015 Marc-Alexandre GHALY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *RangeLabel;
@property (strong, nonatomic) IBOutlet UILabel *NumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *Minlabel;
@property (strong, nonatomic) IBOutlet UILabel *HourLabel;

@end

