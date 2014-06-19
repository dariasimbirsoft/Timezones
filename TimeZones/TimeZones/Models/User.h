//
//  User.h
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import <Foundation/Foundation.h>

// User entity
@interface User : NSObject

@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *authToken;

+(User *) userWithID:(NSString *)userID username:(NSString *)username token:(NSString *)authToken;
@end
