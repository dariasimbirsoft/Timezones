//
//  RequestManager.m
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "RequestManager.h"
#import "User.h"
#import "Timezone.h"

#define BASE_URL @"https://api.parse.com/1/"
#define APP_ID_HEADER @"X-Parse-Application-Id"
#define APP_ID @"mhMXRrIk2vjhx5IysLypVgfVANL8J9DxFT9ABNdj"
#define REST_API_KEY_HEADER @"X-Parse-REST-API-Key"
#define REST_API_KEY @"4q1jIQkCSfqmcIYHRV5UDWYsb2naKlEo63GGFNPh"

#define USERS_API @"users"
#define TIMEZONE_API @"classes/Timezone"
#define TIMEZONES_GET_API @"functions/Timezones"
#define LOGIN_API @"login"
#define RESPONSE_ERROR @"error"

#define OBJECT_ID @"objectId"
#define USERNAME @"username"
#define PASSWORD @"password"
#define SESSION_TOKEN @"sessionToken"

#define TIMEZONE_NAME @"name"
#define TIMEZONE_CITY @"city"
#define TIMEZONE_OFFSET @"offset"
#define TIMEZONE_USER @"user"
#define TIMEZONES_GET_USERID @"userID"
#define TIMEZONES_GET_FILTER @"filter"
#define TIMEZONES_GET_RESULT @"result"

#define USER_CLASS @"_User"
#define RELATION_TYPE @"Pointer"
#define TYPE_FIELD @"__type"
#define CLASS_FIELD @"className"

@implementation RequestManager

+ (instancetype) sharedManager
{
    static RequestManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^(void)
                  {
                      NSURL *baseURL = [NSURL URLWithString:BASE_URL];
                      
                      sharedInstance = [[self alloc] initWithBaseURL:baseURL];
                  });
    
    return sharedInstance;
}

#pragma mark - Initialization

- (instancetype) initWithBaseURL:(NSURL *)url
{
    if ((self = [super initWithBaseURL:url]))
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyNever];
        [self.securityPolicy setAllowInvalidCertificates:YES];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:APP_ID forHTTPHeaderField:APP_ID_HEADER];
        [self.requestSerializer setValue:REST_API_KEY forHTTPHeaderField:REST_API_KEY_HEADER];
    }
    return self;
}


#pragma mark - Auth

- (void) singUpWithLogin:(NSString *)login password:(NSString *)password completion:(void (^)(User *user, NSError* error, NSString *errorMessage))block
{
    NSParameterAssert(login);
    NSParameterAssert(password);
    
    block = [block copy];
    __weak typeof(self) _weakSelf = self;
    NSDictionary* params = @{USERNAME : login, PASSWORD : password};
    
    [self POST:USERS_API parameters:params success:^(AFHTTPRequestOperation* operation, id JSON)
    {
        if(block)
        {
            block([_weakSelf userFromJSON:JSON], nil, nil);
        }
    }
    failure:^(AFHTTPRequestOperation* operation, NSError* error)
    {
        if(block)
        {
            block(nil, error, [_weakSelf errorDescriptionFromOperation:operation]);
        }
    }];
}

- (void) singInWithLogin:(NSString *)login password:(NSString *)password completion:(void (^)(User *user, NSError* error, NSString *errorMessage))block
{
    NSParameterAssert(login);
    NSParameterAssert(password);

    block = [block copy];
    __weak typeof(self) _weakSelf = self;
    NSDictionary* params = @{USERNAME : login, PASSWORD : password};
    
    [self GET:LOGIN_API parameters:params success:^(AFHTTPRequestOperation* operation, id JSON)
    {
        if(block)
        {
            block([_weakSelf userFromJSON:JSON], nil, nil);
        }
     }
     failure:^(AFHTTPRequestOperation* operation, NSError* error)
     {
         if(block)
         {
            block(nil, error, [_weakSelf errorDescriptionFromOperation:operation]);
         }
     }];
}

#pragma mark - Timezones

- (void) createTimezone:(Timezone *)timezone forUser:(User *)user completion:(void (^)(NSError* error, NSString *errorMessage))block
{
    NSParameterAssert(timezone);
    NSParameterAssert(user);
 
    block = [block copy];
    __weak typeof(self) _weakSelf = self;
    NSDictionary* params = @{TIMEZONE_NAME : timezone.name, TIMEZONE_CITY : timezone.city, TIMEZONE_OFFSET : timezone.offset, TIMEZONE_USER : [self relationPointerForUser:user]};
    [self POST:TIMEZONE_API parameters:params success:^(AFHTTPRequestOperation* operation, id JSON)
    {
         if(block)
         {
             block(nil, nil);
         }
    }
    failure:^(AFHTTPRequestOperation* operation, NSError* error)
    {
         if(block)
         {
             block(error, [_weakSelf errorDescriptionFromOperation:operation]);
         }
    }];

}

- (void) updateTimezone:(Timezone *)timezone completion:(void (^)(NSError* error, NSString *errorMessage))block
{
    NSParameterAssert(timezone);

    block = [block copy];
    __weak typeof(self) _weakSelf = self;
    NSDictionary* params = @{TIMEZONE_NAME : timezone.name, TIMEZONE_CITY : timezone.city, TIMEZONE_OFFSET : timezone.offset};
    NSString *url = [NSString stringWithFormat:@"%@/%@", TIMEZONE_API, timezone.timezoneID];
    [self PUT:url parameters:params success:^(AFHTTPRequestOperation* operation, id JSON)
     {
         if(block)
         {
             block(nil, nil);
         }
     }
     failure:^(AFHTTPRequestOperation* operation, NSError* error)
     {
         if(block)
         {
             block(error, [_weakSelf errorDescriptionFromOperation:operation]);
         }
     }];
}

- (void) deleteTimezoneWithID:(NSString *)timezoneID completion:(void (^)(NSError* error, NSString *errorMessage))block
{
    NSParameterAssert(timezoneID);
    
    block = [block copy];
    __weak typeof(self) _weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@/%@", TIMEZONE_API,timezoneID];
    [self DELETE:url parameters:nil success:^(AFHTTPRequestOperation* operation, id JSON)
     {
         if(block)
         {
             block(nil, nil);
         }
     }
      failure:^(AFHTTPRequestOperation* operation, NSError* error)
     {
         if(block)
         {
             block(error, [_weakSelf errorDescriptionFromOperation:operation]);
         }
     }];

}

- (void) getTimezonesForUser:(User *)user usingFilter:(NSString *)filter completion:(void (^)(NSArray *timezones,NSError* error, NSString *errorMessage))block
{
    NSParameterAssert(user);
   
    block = [block copy];
    __weak typeof(self) _weakSelf = self;
    NSDictionary *params;
    if(filter.length > 0)
    {
        params = @{TIMEZONES_GET_USERID : user.userID, TIMEZONES_GET_FILTER : filter};
    }
    else
    {
        params = @{TIMEZONES_GET_USERID : user.userID};
    }
    
    
     [self POST:TIMEZONES_GET_API parameters:params success:^(AFHTTPRequestOperation* operation, id JSON)
     {
         if(block)
         {
            block([_weakSelf getTimezonesFromJSON:JSON], nil, nil);
         }
     }
      failure:^(AFHTTPRequestOperation* operation, NSError* error)
     {
         if(block)
         {
             block(nil, error, [_weakSelf errorDescriptionFromOperation:operation]);
         }
     }];

}


#pragma mark - Utility

- (NSString *) errorDescriptionFromOperation:(AFHTTPRequestOperation *) operation
{
    if(!operation.responseData) return nil;
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:operation.responseData
                          options:kNilOptions
                          error:&error];
    if(error) return nil;
    return  json[RESPONSE_ERROR];
}

- (User *) userFromJSON:(id)JSON
{
    User *user = [User userWithID:JSON[OBJECT_ID] username:JSON[USERNAME] token:JSON[SESSION_TOKEN]];
    return user;
}

- (NSDictionary *) relationPointerForUser:(User *)user
{
    return @{TYPE_FIELD:RELATION_TYPE,CLASS_FIELD:USER_CLASS,OBJECT_ID:user.userID};
}

- (NSArray *) getTimezonesFromJSON:(id)JSON
{
    NSMutableArray *array = [NSMutableArray array];
    [JSON[TIMEZONES_GET_RESULT] enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop)
     {
         Timezone *timezone = [Timezone timezoneWithID:obj[OBJECT_ID] name:obj[TIMEZONE_NAME] city:obj[TIMEZONE_CITY] offset:obj[TIMEZONE_OFFSET]];
         [array addObject:timezone];
     }];
     return array;
}

@end
