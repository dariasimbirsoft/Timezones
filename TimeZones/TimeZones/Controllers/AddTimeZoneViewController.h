//
//  AddTimeZoneViewController.h
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInputViewController.h"

@class Timezone;

@interface AddTimeZoneViewController : BaseInputViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *offsetPickerView;
@property (strong, nonatomic) Timezone *editingTimezone;

- (IBAction)saveTapped:(id)sender;
@end
