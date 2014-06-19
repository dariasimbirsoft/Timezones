//
//  BaseInputViewController.h
//  TimeZones
//
//  Created by Daria on 19/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseInputViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;


- (void) showActivityView;
- (void) hideActivityView;
- (void) hideKeyboard;
@end
