//
//  UIAlertView+ShowError.m
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "UIAlertView+ShowError.h"
#import "defines.h"

@implementation UIAlertView (ShowError)

+(void)showAlertViewWithErrorMessage:(NSString *)message;
{
    NSString *messageText = (message)?message:NSLocalizedString(SERVER_ERROR, nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(ERROR_TITLE, nil) message:messageText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)showAlertViewWithWarningMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(WARNING_TITLE, nil) message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
@end
