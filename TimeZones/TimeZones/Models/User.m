//
//  User.m
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "User.h"

@implementation User

+(User *) userWithID:(NSString *)userID username:(NSString *)username token:(NSString *)authToken
{
    User *user = [[User alloc] init];
    user.userID = userID;
    user.username = username;
    user.authToken = authToken;
    return user;
}
@end
