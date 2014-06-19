//
//  Timezone.m
//  TimeZones
//
//  Created by Daria on 17/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "Timezone.h"

@implementation Timezone

+(Timezone *) timezoneWithName:(NSString *)name city:(NSString *)city offset:(NSNumber *)offset
{
    return [self timezoneWithID:nil name:name city:city offset:offset];
}

+(Timezone *) timezoneWithID:(NSString *)timezoneID name:(NSString *)name city:(NSString *)city offset:(NSNumber *)offset
{
    Timezone *timezone = [[Timezone alloc] init];
    timezone.timezoneID = timezoneID;
    timezone.name = name;
    timezone.city = city;
    timezone.offset = offset;
    return timezone;
}

+(Timezone *) timezoneWithID:(NSString *)timezoneID name:(NSString *)name city:(NSString *)city hours:(NSInteger)hours minutes:(NSInteger)minutes
{
    NSInteger sign = (hours >=0)?1:-1;
    hours = MIN(ABS(hours), TIMEZONES_LENGTH);
    if(hours == TIMEZONES_LENGTH) minutes = 0;
    NSNumber *offset = [NSNumber numberWithInteger:sign*(hours*60 + minutes)];
    return [self timezoneWithID:timezoneID name:name city:city offset:offset];
}

-(NSString *) offsetString
{
    NSInteger number = [self.offset integerValue];
    NSString *sign = (number >=0)?@"+":@"-";
    number = ABS(number);
    NSInteger hours = number / 60;
    NSInteger minutes = number % 60;
    return [NSString stringWithFormat:@"GMT%@%d:%02d",sign, hours, minutes];
}

- (NSInteger) offsetHours
{
    NSInteger number = [self.offset integerValue];
    NSInteger hours = ABS(number)/60;
    return (number >=0)?hours:-hours;
}

- (NSInteger) offsetMinutes
{
    NSInteger number = [self.offset integerValue];
    return (ABS(number)%60);
}

- (NSDate *) dateForUTC:(NSDate *)utcDate
{
    return [NSDate dateWithTimeInterval:[self.offset doubleValue]*60.0 sinceDate:utcDate];
}

- (NSString *) dateStringForUTC:(NSDate *)utcDate;
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    return [dateFormatter stringFromDate:[self dateForUTC:utcDate]];
}

@end
