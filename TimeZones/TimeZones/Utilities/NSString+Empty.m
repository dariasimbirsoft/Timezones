//
//  NSString+Empty.m
//  TimeZones
//
//  Created by Daria on 18/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import "NSString+Empty.h"

@implementation NSString (Empty)

- (BOOL) isEmptyOrWhitespaces
{
    if(self.length == 0) return true;
    if([self stringByTrimming].length == 0) return  true;
    return false;
}

- (NSString *) stringByTrimming
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end
