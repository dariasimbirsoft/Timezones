//
//  SingUpViewController.m
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "SingUpViewController.h"
#import "RequestManager.h"
#import "UIAlertView+ShowError.h"
#import "AppDelegate.h"
#import "NSString+Empty.h"
#import "defines.h"

@interface SingUpViewController ()

@end

@implementation SingUpViewController


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

- (IBAction)singUpTapped:(id)sender
{
    NSString *login = [self.loginTextField.text stringByTrimming];
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    if(login.length == 0)
    {
        [UIAlertView showAlertViewWithWarningMessage:NSLocalizedString(EMPTY_LOGIN_ERROR, nil)];
        return;
    }
    if([password isEmptyOrWhitespaces])
    {
        [UIAlertView showAlertViewWithWarningMessage:NSLocalizedString(EMPTY_PASSWORD_ERROR, nil)];
        return;
    }
    if(![password isEqualToString:confirmPassword])
    {
        [UIAlertView showAlertViewWithWarningMessage:NSLocalizedString(PASSWORD_CONFIRM_ERROR, nil)];
        return;
    }
    [self singUpWithLogin:login password:password];
}

- (void) singUpWithLogin:(NSString *)login password:(NSString *)password
{
    __weak typeof(self) _weakSelf = self;
    [self hideKeyboard];
    [self showActivityView];
    [[RequestManager sharedManager] singUpWithLogin:login password:password completion:^(User *user, NSError* error, NSString *errorMessage)
     {
         [_weakSelf hideActivityView];
         if(error)
         {
             [UIAlertView showAlertViewWithErrorMessage:errorMessage];
         }
         else
         {
             AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
             appDelegate.currentUser = user;
             [_weakSelf performSegueWithIdentifier:MAIN_SCREEN_SEGUE sender:nil];
         }
     }];
    
}

@end
