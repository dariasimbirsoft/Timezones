//
//  Timezone.h
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIMEZONES_LENGTH 12

// Timezone entity
@interface Timezone : NSObject

@property(nonatomic, copy) NSString *timezoneID;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *city;
// GMT offset in minutes
@property(nonatomic, strong) NSNumber *offset;

+(Timezone *) timezoneWithName:(NSString *)name city:(NSString *)city offset:(NSNumber *)offset;
+(Timezone *) timezoneWithID:(NSString *)timezoneID name:(NSString *)name city:(NSString *)city offset:(NSNumber *)offset;
+(Timezone *) timezoneWithID:(NSString *)timezoneID name:(NSString *)name city:(NSString *)city hours:(NSInteger)offsetHours minutes:(NSInteger)minutes;
// return string representation of GMT offset
- (NSString *) offsetString;
// return GMT offset hours part
- (NSInteger) offsetHours;
// return GMT offset minutes part
- (NSInteger) offsetMinutes;
// return timezone local time for UTC time
- (NSDate *) dateForUTC:(NSDate *)utcDate;
// return string representation of timezone local time
- (NSString *) dateStringForUTC:(NSDate *)utcDate;
@end
