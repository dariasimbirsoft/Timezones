//
//  TimeZonesViewController.h
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeZonesViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *filterTextField;
@property (weak, nonatomic) IBOutlet UIButton *delButton;

- (IBAction)delTapped:(id)sender;
- (IBAction)refresh:(id)sender;
@end
