//
//  SGPostBodyLabel.m
//  ALDynamicCellHeights
//
//  Created by Justin Williams on 10/30/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGPostBodyLabel.h"

@implementation SGPostBodyLabel

- (void)layoutSubviews
{
    self.preferredMaxLayoutWidth = self.frame.size.width;
    [super layoutSubviews];
}

@end
