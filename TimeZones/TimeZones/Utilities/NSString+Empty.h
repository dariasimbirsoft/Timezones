//
//  NSString+Empty.h
//  TimeZones
//
//  Created by Daria on 18/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Empty)

- (BOOL) isEmptyOrWhitespaces;
- (NSString *) stringByTrimming;
@end
