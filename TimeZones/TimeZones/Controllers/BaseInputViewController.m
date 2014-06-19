//
//  BaseInputViewController.m
//  TimeZones
//
//  Created by Daria on 19/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "BaseInputViewController.h"

@interface BaseInputViewController ()

@end

@implementation BaseInputViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showActivityView
{
    self.activityView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void) hideActivityView
{
    [self.activityIndicatorView stopAnimating];
    self.activityView.hidden = YES;
}

- (void) hideKeyboard
{
    [self.textFields enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop)
    {
        if([obj isFirstResponder])
        {
            [obj resignFirstResponder];
            *stop = YES;
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField*)textField
{
    __block BOOL found = NO;
    NSInteger tag = textField.tag + 1;
    [self.textFields enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop)
     {
         if(((UITextField *)obj).tag == tag)
         {
             [obj becomeFirstResponder];
             *stop = YES;
             found = YES;
         }
     }];
    if(!found)
    {
        [textField resignFirstResponder];
    }
    return NO;
}


@end
