//
//  TimeZonesViewController.m
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "TimeZonesViewController.h"
#import "RequestManager.h"
#import "AppDelegate.h"
#import "User.h"
#import "Timezone.h"
#import "TableViewCell.h"
#import "NSString+Empty.h"
#import "UIAlertView+ShowError.h"
#import "AddTimeZoneViewController.h"
#import "defines.h"

@interface TimeZonesViewController ()

@end

@implementation TimeZonesViewController
{
    NSArray *_timezones;
    NSString *_filter;
    NSDate *_currentDate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentDate = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set footer to hide empty cells at the bottom of table view
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(LOGOUT_BUTTON_TITLE, nil) style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTableEditMode:NO];
    [self beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideKeyboard];
}

- (IBAction)delTapped:(id)sender
{
    [self setTableEditMode:!self.tableView.isEditing];
}

- (IBAction)refresh:(id)sender
{
    User *user = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentUser;
    __weak typeof(self) _weakSelf = self;
    [[RequestManager sharedManager] getTimezonesForUser:user usingFilter:_filter completion:^(NSArray *timezones, NSError* error, NSString *errorMessage)
     {
         [_weakSelf endRefreshing];
         if(error)
         {
             [UIAlertView showAlertViewWithErrorMessage:errorMessage];
         }
         else
         {
             [_weakSelf setTimezones:timezones];
         }
     }];
}

- (void) beginRefreshing
{
    [self.tableView setContentOffset:CGPointMake(0, -1.0 * self.refreshControl.frame.size.height) animated:NO];
    [self.refreshControl beginRefreshing];
    [self refresh:nil];
}

- (void) endRefreshing
{
    [self.refreshControl endRefreshing];
}

- (void) back:(id)sender
{
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentUser = nil;
    [self performSegueWithIdentifier:LOGOUT_SEGUE sender:nil];
}

- (void) setTimezones:(NSArray *) timezones
{
    _timezones = [timezones copy];
    _currentDate = [NSDate date];
    [self.tableView reloadData];
    if(_timezones.count == 0)
    {
         [self setTableEditMode:NO];
         self.delButton.enabled = NO;
    }
    else
    {
        self.delButton.enabled = YES;
    }
}

-(IBAction)backToMainScreen:(UIStoryboardSegue *)segue
{
    
}

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:EDIT_TIMEZONE_SEGUE])
    {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        Timezone *timezone = [_timezones objectAtIndex:indexPath.row];
        AddTimeZoneViewController *controller = segue.destinationViewController;
        controller.editingTimezone = timezone;
    }
    else
    {
        [super prepareForSegue:segue sender:sender];
    }
}

- (void) setTableEditMode:(BOOL)editing
{
    [self.tableView setEditing:editing];
    NSString *title = NSLocalizedString((editing)?DONE_BUTTON_TITLE:DELETE_TIMEZONE_BUTTON_TITLE , nil);
    [self.delButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - UITableView delegate and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _timezones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    Timezone *timezone = [_timezones objectAtIndex:indexPath.row];
    cell.nameLabel.text = timezone.name;
    cell.cityLabel.text = timezone.city;
    cell.gmtOffsetLabel.text = [timezone offsetString];
    cell.currentTimeLabel.text = [timezone dateStringForUTC:_currentDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Timezone *timezone = [_timezones objectAtIndex:indexPath.row];
    __weak typeof(self) _weakSelf = self;
    [[RequestManager sharedManager] deleteTimezoneWithID:timezone.timezoneID completion:^(NSError* error, NSString *errorMessage)
     {
         if(error)
         {
             [UIAlertView showAlertViewWithErrorMessage:errorMessage];
         }
         else
         {
             [_weakSelf beginRefreshing];
         }
     }];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField*)textField
{
    _filter = [textField.text stringByTrimming];
    [textField resignFirstResponder];
    [self beginRefreshing];
    return NO;
}

- (void) hideKeyboard
{
    [self.filterTextField resignFirstResponder];
    self.filterTextField.text = _filter;
}

@end
