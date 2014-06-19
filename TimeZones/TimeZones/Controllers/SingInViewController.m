//
//  SingInViewController.m
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "SingInViewController.h"
#import "RequestManager.h"
#import "UIAlertView+ShowError.h"
#import "AppDelegate.h"
#import "NSString+Empty.h"
#import "defines.h"

@interface SingInViewController ()

@end

@implementation SingInViewController

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

- (IBAction)singInTapped:(id)sender
{
    NSString *login = [self.loginTextField.text stringByTrimming];
    NSString *password = self.passwordTextField.text;
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
    [self singInWithLogin:login password:password];
}

- (void) singInWithLogin:(NSString *)login password:(NSString *)password
{
    __weak typeof(self) _weakSelf = self;
    [self hideKeyboard];
    [self showActivityView];
    [[RequestManager sharedManager] singInWithLogin:login password:password completion:^(User *user, NSError* error, NSString *errorMessage)
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
