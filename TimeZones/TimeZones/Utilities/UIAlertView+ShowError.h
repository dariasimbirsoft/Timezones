//
//  UIAlertView+ShowError.h
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (ShowError)

+(void)showAlertViewWithErrorMessage:(NSString *)message;
+ (void)showAlertViewWithWarningMessage:(NSString *)message;
@end
