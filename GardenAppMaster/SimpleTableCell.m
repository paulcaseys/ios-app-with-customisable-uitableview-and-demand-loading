//
//  SimpleTableCell.m
//  GardenAppMaster
//
//  Created by PAUL CASEY on 2013-06-16.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "SimpleTableCell.h"


@implementation SimpleTableCell

@synthesize nameLabel = _nameLabel;
@synthesize timeLabel = _timeLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
