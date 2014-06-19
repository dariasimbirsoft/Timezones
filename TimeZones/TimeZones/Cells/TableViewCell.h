//
//  TableViewCell.h
//  TimeZones
//
//  Created by Daria on 18/06/14.
//  Copyright (c) 2014 Daria Sukhonosova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *gmtOffsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@end
