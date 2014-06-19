//
//  AddTimeZoneViewController.m
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "AddTimeZoneViewController.h"
#import "RequestManager.h"
#import "Timezone.h"
#import "User.h"
#import "AppDelegate.h"
#import "UIAlertView+ShowError.h"
#import "NSString+Empty.h"
#import "defines.h"

#define MIN_STEP 5
#define STEP_COUNT 12

@interface AddTimeZoneViewController ()
@end

@implementation AddTimeZoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.editingTimezone)
    {
        self.nameTextField.text = self.editingTimezone.name;
        self.cityTextField.text = self.editingTimezone.city;
        [self.offsetPickerView selectRow:[self rowForHours:[self.editingTimezone offsetHours]] inComponent:1 animated:NO];
        [self.offsetPickerView selectRow:[self rowForMinutes:[self.editingTimezone offsetMinutes]] inComponent:3 animated:NO];
    }
    else
    {
        [self.offsetPickerView selectRow:TIMEZONES_LENGTH inComponent:1 animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveTapped:(id)sender
{
   NSString *name = [self.nameTextField.text stringByTrimming];
   NSString *city = [self.cityTextField.text stringByTrimming];
   if(name.length == 0)
   {
       [UIAlertView showAlertViewWithWarningMessage:NSLocalizedString(EMPTY_TIMEZONE_NAME, nil)];
       return;
   }
   if(city.length == 0)
   {
        [UIAlertView showAlertViewWithWarningMessage:NSLocalizedString(EMPTY_TIMEZONE_CITY, nil)];
        return;
   }
   NSInteger hours = [self hoursInRow:[self.offsetPickerView selectedRowInComponent:1]];
   NSInteger minutes = [self minutesInRow:[self.offsetPickerView selectedRowInComponent:3]];
   [self saveTimezoneWithName:name city:city hours:hours minutes:minutes];
}

- (void) saveTimezoneWithName:(NSString *)name city:(NSString *)city hours:(NSInteger)hours minutes:(NSInteger)minutes
{
    NSString *timezoneID = (self.editingTimezone)?self.editingTimezone.timezoneID:nil;
    Timezone *timezone = [Timezone timezoneWithID:timezoneID name:name city:city hours:hours minutes:minutes];
    __weak typeof(self) _weakSelf = self;
    void (^block)(NSError* error, NSString *errorMessage) = ^(NSError* error, NSString *errorMessage)
    {
        [_weakSelf hideActivityView];
        if(error)
        {
            [UIAlertView showAlertViewWithErrorMessage:errorMessage];
        }
        else
        {
            [_weakSelf performSegueWithIdentifier:BACK_SEGUE sender:nil];
        }
    };
    [self hideKeyboard];
    [self showActivityView];
    if(self.editingTimezone)
    {
        [[RequestManager sharedManager] updateTimezone:timezone completion:block];
    }
    else
    {
        User *user = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentUser;
        [[RequestManager sharedManager] createTimezone:timezone forUser:user completion:block];
    }
}

#pragma mark - UIPickerView delegate and data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        case 2:
           return 1;
    
        case 1:
            return TIMEZONES_LENGTH*2 + 1;
            
        case 3:
            return STEP_COUNT;
            
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
             return @"GMT";
    
        case 1:
            return [NSString stringWithFormat:@"%d", [self hoursInRow:row]];
            
        case 2:
            return @":";
            
        case 3:
            return [NSString stringWithFormat:@"%d", [self minutesInRow:row]];
            
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 1 && (row == 0 || row == TIMEZONES_LENGTH * 2))
    {
        [pickerView selectRow:0 inComponent:3 animated:YES];
    }
}

- (NSInteger) hoursInRow:(NSInteger)row
{
    return (-TIMEZONES_LENGTH + row);
}

- (NSInteger) minutesInRow:(NSInteger)row
{
    return (MIN_STEP*row);
}

- (NSInteger) rowForHours:(NSInteger)hours
{
    NSInteger row = hours + TIMEZONES_LENGTH;
    return MAX(MIN(row, TIMEZONES_LENGTH*2), 0);
}

- (NSInteger) rowForMinutes:(NSInteger)minutes
{
    NSInteger row = minutes/MIN_STEP;
    return MAX(MIN(row, STEP_COUNT - 1), 0);
}

@end
