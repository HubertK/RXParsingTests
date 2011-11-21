//
//  ListCell.m
//  RxLookup
//
//  Created by Helene Brooks on 11/20/11.
//  Copyright (c) 2011 vaughn. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell
@synthesize medicine;

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
