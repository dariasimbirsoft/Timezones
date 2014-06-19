//
//  SingUpViewController.h
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInputViewController.h"

@interface SingUpViewController : BaseInputViewController

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

- (IBAction)singUpTapped:(id)sender;
@end
