//
//  RequestManager.h
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class User;
@class Timezone;

@interface RequestManager : AFHTTPRequestOperationManager

+ (instancetype) sharedManager;
// sing up method
- (void) singUpWithLogin:(NSString *)login password:(NSString *)password completion:(void (^)(User *user, NSError* error, NSString *errorMessage))block;
// sing in method
- (void) singInWithLogin:(NSString *)login password:(NSString *)password completion:(void (^)(User *user, NSError* error, NSString *errorMessage))block;
// create new timezone for user
- (void) createTimezone:(Timezone *)timezone forUser:(User *)user completion:(void (^)(NSError* error, NSString *errorMessage))block;
// update existing timezone
- (void) updateTimezone:(Timezone *)timezone completion:(void (^)(NSError* error, NSString *errorMessage))block;
// delete timezone by ID
- (void) deleteTimezoneWithID:(NSString *)timezoneID completion:(void (^)(NSError* error, NSString *errorMessage))block;
// get all timezones for user with filtering by timezone name
- (void) getTimezonesForUser:(User *)user usingFilter:(NSString *)filter completion:(void (^)(NSArray *timezones,NSError* error, NSString *errorMessage))block;

@end
